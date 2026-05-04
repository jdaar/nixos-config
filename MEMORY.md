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

## What Works
- TLS certificates have IP SANs
- CA-signed certs
- CA cert mounted in Headlamp pod
- OIDC discovery endpoint accessible from Headlamp pod
- Keycloak token endpoint works
- Keycloak login page renders correctly
- PKCE S256 enabled on Keycloak client (matched with Headlamp)
- OIDC auth code flow completes successfully (callback sets auth cookie)
- Keycloak issues valid ID tokens and refresh tokens

## Root Cause (RESOLVED 2026-05-04)
The K8s API server (k3s) had **no OIDC authentication configured**. Headlamp successfully authenticated users via Keycloak and set the auth cookie, but when proxying API requests with the OIDC token as Bearer token, the K8s API server rejected them with 401 because it couldn't validate OIDC tokens.

Fix: Added `--kube-apiserver-arg=--oidc-*` flags to k3s server config so the API server validates tokens against the Keycloak issuer.

## Realm Rename (PENDING DEPLOY)
Realm renamed from `headlamp` to `k8s-sso` to reflect multi-purpose SSO intent. Changes are in `k8s.nix` but not yet deployed. After deploy, the old `headlamp` realm in Keycloak should be manually deleted.

## Config files changed
- `/etc/nixos/hosts/server/k8s.nix`:
  - Realm JSON: `"realm": "k8s-sso"`, `"default-roles-k8s-sso"`
  - PKCE attribute added to client: `"pkce.code.challenge.method": "S256"`
  - Headlamp issuerURL: `https://152.53.135.19/keycloak/realms/k8s-sso`
  - k3s extraFlags with OIDC apiserver args
  - CA cert in `environment.etc."k3s-oidc-ca.crt"`
  - ConfigMap key renamed: `k8s-sso-realm.json`

## k3s OIDC Configuration (PENDING DEPLOY)
- `--oidc-issuer-url=https://152.53.135.19/keycloak/realms/k8s-sso`
- `--oidc-client-id=headlamp`
- `--oidc-ca-file=/etc/k3s-oidc-ca.crt`
- `--oidc-username-claim=preferred_username`
- `--oidc-groups-claim=realm_access.roles`

## Keycloak Client Current State (via admin API)
- clientId: headlamp
- secret: headlamp-client-secret
- redirectUris: ["https://152.53.135.19/*"]
- webOrigins: ["https://152.53.135.19"]
- standardFlowEnabled: true
- directAccessGrantsEnabled: true
- publicClient: false
- pkce.code.challenge.method: S256

## Headlamp OIDC Config (will update on deploy)
- issuerURL: https://152.53.135.19/keycloak/realms/k8s-sso
- callbackURL: https://152.53.135.19/oidc-callback
- clientID: headlamp
- clientSecret: headlamp-client-secret
- scopes: openid profile email
- usePKCE: true
- oidc-ca-file: /etc/ssl/certs/ca.crt

## Deploy Instructions
```bash
git push  # push changes
ssh server 'cd /etc/nixos && git pull && sudo nixos-rebuild switch --flake .#server'
```
After deploy, delete the old `headlamp` realm from Keycloak via admin API.

## Debugging Commands
```bash
# Check Headlamp logs
k3s kubectl logs -n headlamp -l app.kubernetes.io/name=headlamp --tail=100 | grep -v "refreshing token\|Request completed"

# Check Keycloak auth errors
k3s kubectl logs -n keycloak -l app=keycloak --tail=50 | grep -iE "error|warn|invalid|login"

# Test token exchange from Headlamp pod
POD=$(k3s kubectl get pods -n headlamp -l app.kubernetes.io/name=headlamp -o jsonpath="{.items[0].metadata.name}")
k3s kubectl exec -n headlamp $POD -- wget -q -O- --no-check-certificate "https://152.53.135.19/keycloak/realms/k8s-sso/protocol/openid-connect/token" --post-data="grant_type=password&client_id=headlamp&client_secret=headlamp-client-secret&username=admin&password=admin&scope=openid"

# Full OIDC flow test (from server)
bash /tmp/e2e_test.sh
```