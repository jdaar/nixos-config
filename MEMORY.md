# Headlamp + Keycloak OIDC Setup - Session Context

## Infrastructure
- NixOS server at 152.53.135.19 running k3s
- Keycloak 26.0 in `keycloak` namespace, realm `k8s-sso`
- Headlamp in `headlamp` namespace via Helm
- Traefik ingress, cert-manager with self-signed CA hierarchy

## Access
- SSH: `ssh jhonatan@152.53.135.19`
- Keycloak admin: https://152.53.135.19/keycloak (admin/admin)
- Headlamp: https://152.53.135.19/

## Current Problem (UNRESOLVED)
k3s apiserver OIDC authenticator fails with:
```
tls: failed to verify certificate: x509: certificate signed by unknown authority
```

**Root cause**: Traefik serves TLS with only the leaf certificate, not the full chain. Go's `crypto/tls` doesn't use a separate CA file for server verification - it needs either the full chain from the server OR the CA in the system trust store. The `--oidc-ca-file` flag alone doesn't work for Go clients making HTTPS connections when the server doesn't send the chain.

**Fix applied but not yet deployed**: 
1. `security.pki.certificateFiles` in k8s.nix - adds root CA to NixOS system trust store (`/etc/ssl/certs/`)
2. This makes the root CA trusted system-wide, so k3s (Go binary) will verify it

**Deploy with**: `cd /etc/nixos && git pull && sudo nixos-rebuild switch --flake .#server`

## IMPORTANT: Root CA changes on every cluster rebuild!
cert-manager generates a new self-signed root CA every time the cluster is rebuilt. After rebuild, extract the new root CA and update `hosts/server/root-ca.crt`:
```bash
KUBECONFIG=/etc/rancher/k3s/k3s.yaml kubectl get secret -n cert-manager root-ca-tls -o go-template="{{index .data \"tls.crt\"}}" | base64 -d > /etc/nixos/hosts/server/root-ca.crt
```

## What Works
- TLS certs with IP SANs
- OIDC auth code flow (Headlamp -> Keycloak -> callback -> cookie set)
- PKCE S256 on Keycloak client matching Headlamp config
- Realm renamed to `k8s-sso`
- k3s OIDC apiserver flags configured
- CA cert file present at `/etc/k3s-oidc-ca.crt` (correct content)
- CA cert added to `security.pki.certificateFiles` (pending deploy)

## What Doesn't Work Yet
- k3s can't verify Keycloak's TLS cert (not in system trust store yet)
- Therefore OIDC auth to K8s API returns 401
- Headlamp login redirects succeed but API proxy fails

## k3s OIDC Configuration
- `--oidc-issuer-url=https://152.53.135.19/keycloak/realms/k8s-sso`
- `--oidc-client-id=headlamp`
- `--oidc-ca-file=/etc/k3s-oidc-ca.crt`
- `--oidc-username-claim=preferred_username`
- `--oidc-groups-claim=realm_access.roles`

## Keycloak Client
- clientId: headlamp, secret: headlamp-client-secret
- PKCE S256 enabled
- redirectUris: ["https://152.53.135.19/*"]

## Deploy Commands
```bash
# On local machine (after code changes):
git push

# On server:
cd /etc/nixos && git pull && sudo nixos-rebuild switch --flake .#server

# After cluster rebuild, update root CA:
KUBECONFIG=/etc/rancher/k3s/k3s.yaml kubectl get secret -n cert-manager root-ca-tls -o go-template="{{index .data \"tls.crt\"}}" | base64 -d > /etc/nixos/hosts/server/root-ca.crt
# Then commit, push, and rebuild again
```