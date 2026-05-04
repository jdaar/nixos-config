# Headlamp + Keycloak OIDC Setup - Session Context

## Infrastructure
- NixOS server at 152.53.135.19 running k3s
- Keycloak 26.0 deployed in `keycloak` namespace
- Headlamp deployed in `headlamp` namespace via Helm
- Traefik as ingress controller (k3s embedded)
- cert-manager with CA hierarchy: selfsigned ClusterIssuer -> root-ca cert -> ca-issuer ClusterIssuer -> TLS certs with IP SAN 152.53.135.19

## Access
- SSH: `ssh jhonatan@152.53.135.19`
- kubectl: `KUBECONFIG=/etc/rancher/k3s/k3s.yaml kubectl` or `k3s kubectl`
- Keycloak admin: https://152.53.135.19/keycloak (admin/admin)
- Headlamp: https://152.53.135.19/

## Current Problem (UNRESOLVED)
After cluster rebuild, the k3s OIDC authenticator fails with:
```
oidc authenticator: initializing plugin: Get "https://152.53.135.19/keycloak/realms/k8s-sso/.well-known/openid-configuration": tls: failed to verify certificate: x509: certificate signed by unknown authority
```

**Root cause**: The `/etc/k3s-oidc-ca.crt` file on the server still contains the OLD cluster's root CA cert (serial `11A0...`). The cluster was rebuilt and cert-manager generated a NEW root CA (serial `4E18...`). The NixOS config was updated with the correct CA cert (commit `4886d36`) but `nixos-rebuild switch` hasn't been applied yet.

**Fix**: Run on the server:
```bash
cd /etc/nixos && git pull && sudo nixos-rebuild switch --flake .#server
```

## What Works
- TLS certificates have IP SANs
- CA-signed certs
- OIDC discovery endpoint accessible from Headlamp pod
- Keycloak token endpoint works
- Keycloak login page renders correctly
- PKCE S256 enabled on Keycloak client
- OIDC auth code flow completes successfully (Headlamp sets auth cookie)
- Realm renamed from `headlamp` to `k8s-sso` in ConfigMap and Headlamp config
- k3s OIDC apiserver flags configured (issuer, client-id, ca-file, username-claim, groups-claim)

## What Doesn't Work Yet
- k3s apiserver can't verify Keycloak's TLS cert (stale CA file)
- Therefore OIDC auth to K8s API fails (401 Unauthorized)
- Headlamp login flow succeeds but API proxy returns 401

## Key Files
- `/etc/nixos/hosts/server/k8s.nix` - All k8s manifests, OIDC flags, CA cert

## Realm Rename (Applied in ConfigMap, not yet deployed)
- ConfigMap key: `k8s-sso-realm.json` (was `headlamp-realm.json`)
- Realm: `k8s-sso` (was `headlamp`)
- Headlamp issuerURL: `https://152.53.135.19/keycloak/realms/k8s-sso`
- Default roles: `default-roles-k8s-sso`

## k3s OIDC Configuration (Applied in k8s.nix, not yet effective)
- `--oidc-issuer-url=https://152.53.135.19/keycloak/realms/k8s-sso`
- `--oidc-client-id=headlamp`
- `--oidc-ca-file=/etc/k3s-oidc-ca.crt`
- `--oidc-username-claim=preferred_username`
- `--oidc-groups-claim=realm_access.roles`

## Root CA Cert (IMPORTANT - changes on every cluster rebuild!)
cert-manager generates a new self-signed root CA every time the cluster is rebuilt. The CA cert in `k8s.nix` must be updated to match. To get the current root CA:
```bash
KUBECONFIG=/etc/rancher/k3s/k3s.yaml kubectl get secret -n cert-manager root-ca-tls -o go-template="{{index .data \"tls.crt\"}}" | base64 -d
```
The current CA cert in k8s.nix (correct, serial 4E18) matches the running cluster. The file on disk at `/etc/k3s-oidc-ca.crt` still has the old cert and needs nixos-rebuild.

## Keycloak Client Current State (running ConfigMap)
- clientId: headlamp
- secret: headlamp-client-secret
- redirectUris: ["https://152.53.135.19/*"]
- webOrigins: ["https://152.53.135.19"]
- standardFlowEnabled: true
- directAccessGrantsEnabled: true
- publicClient: false
- pkce.code.challenge.method: S256

## Headlamp OIDC Config (running)
- issuerURL: https://152.53.135.19/keycloak/realms/k8s-sso
- callbackURL: https://152.53.135.19/oidc-callback
- clientID: headlamp
- clientSecret: headlamp-client-secret
- scopes: openid profile email
- usePKCE: true
- oidc-ca-file: /etc/ssl/certs/ca.crt (mounted from headlamp-tls secret)

## Architecture: How Headlamp OIDC Auth Works
1. Browser hits `/oidc?cluster=main` -> 302 to Keycloak auth URL (with PKCE code_challenge)
2. User logs in at Keycloak -> 302 to `/oidc-callback?code=...&state=...`
3. Headlamp exchanges auth code for tokens (using code_verifier for PKCE)
4. Headlamp stores refresh_token in in-memory cache keyed by id_token JWT
5. Headlamp sets `headlamp-auth-main.0` cookie containing the id_token
6. On subsequent API requests, Headlamp extracts token from cookie, checks JWT exp
7. If token about to expire, Headlamp refreshes using stored refresh_token
8. Headlamp proxies request to K8s API with the id_token as Bearer token
9. K8s API server validates the Bearer token against the OIDC issuer

Step 9 is where it currently fails - k3s can't validate because it can't verify the TLS cert of the Keycloak issuer URL.

## Previous Root Cause (RESOLVED)
The original "Session doesn't have required client" error was caused by:
1. PKCE mismatch: Keycloak client had no `pkce.code.challenge.method` while Headlamp had `usePKCE: true`
2. Stale sessions from a previous client UUID change

These were fixed by adding `pkce.code.challenge.method: S256` to the Keycloak client.

## Debugging Commands
```bash
# Check k3s OIDC initialization status
journalctl -u k3s --no-pager -n 10 | grep -i oidc

# Check if CA cert matches running cluster
openssl x509 -in /etc/k3s-oidc-ca.crt -noout -serial
KUBECONFIG=/etc/rancher/k3s/k3s.yaml kubectl get secret -n cert-manager root-ca-tls -o go-template="{{index .data \"tls.crt\"}}" | base64 -d | openssl x509 -noout -serial

# Verify TLS chain with correct CA
nix-shell -p curl -p openssl --run "curl -sk --cacert /etc/k3s-oidc-ca.crt https://152.53.135.19/keycloak/realms/k8s-sso/.well-known/openid-configuration | jq .issuer"

# Full OIDC flow test
bash /tmp/e2e_test.sh

# Check Headlamp logs
k3s kubectl logs -n headlamp -l app.kubernetes.io/name=headlamp --tail=100 | grep -v "refreshing token\|Request completed"

# Check Keycloak auth errors
k3s kubectl logs -n keycloak -l app=keycloak --tail=50 | grep -iE "error|warn|invalid|login"

# Get current root CA for updating k8s.nix
KUBECONFIG=/etc/rancher/k3s/k3s.yaml kubectl get secret -n cert-manager root-ca-tls -o go-template="{{index .data \"tls.crt\"}}" | base64 -d
```