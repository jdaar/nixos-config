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
- TLS certificates have IP SANs (fixed original "no IP SANs" error)
- CA-signed certs (fixed "unknown authority" error)
- CA cert mounted in Headlamp pod at /etc/ssl/certs/ca.crt via -oidc-ca-file
- OIDC discovery endpoint accessible from Headlamp pod
- Keycloak token endpoint works: password grant returns valid tokens with correct issuer
- Keycloak login page renders correctly
- PKCE enforcement removed from Keycloak client attributes

## Current Problem
After authenticating with Keycloak, Headlamp redirects back to `/auth?cluster=main` but the user is not actually authenticated. The browser appears logged in but Headlamp doesn't grant access.

Keycloak logs show when a user DOES log in:
```
REFRESH_TOKEN_ERROR ... "Session doesn't have required client"
```

This means: the initial authorization code exchange fails silently, and Headlamp falls back to refreshing a broken/stale token every 5 seconds.

## Root Cause Analysis (UNRESOLVED)
The most likely cause: the Keycloak `headlamp` client was **deleted and recreated** (via `kubectl exec` admin API) to remove the `pkce.code.challenge.method` attribute. This changed the client's internal UUID. Any sessions/tokens created BEFORE the recreation reference the OLD client UUID, causing "Session doesn't have required client".

However, even new login attempts from incognito appear to fail. The Headlamp logs only show stale "refreshing token: key not found" errors and no new auth flow logs. This means either:
1. The browser auth flow completes but the callback to Headlamp fails silently
2. Headlamp's OIDC callback handler has a bug or misconfiguration
3. The Headlamp OIDC state/nonce doesn't match what Keycloak returns

## Key Files
- `/etc/nixos/hosts/server/k8s.nix` - All k8s manifests (Keycloak, Headlamp, cert-manager, etc.)
- Keycloak realm config is imported from the ConfigMap `keycloak-realm` in `keycloak` namespace
- `--spi-realm-import-strategy=OVERWRITE_EXISTING` is set on Keycloak

## Keycloak Client Current State (via admin API)
- clientId: headlamp
- secret: headlamp-client-secret
- redirectUris: ["https://152.53.135.19/*"]
- webOrigins: ["https://152.53.135.19"]
- standardFlowEnabled: true
- directAccessGrantsEnabled: true
- publicClient: false
- pkce.code.challenge.method: REMOVED (was S256, deleted via admin API)

## Headlamp OIDC Config (running)
- issuerURL: https://152.53.135.19/keycloak/realms/headlamp
- callbackURL: https://152.53.135.19/oidc-callback
- clientID: headlamp
- clientSecret: headlamp-client-secret
- scopes: openid profile email
- usePKCE: true
- oidc-ca-file: /etc/ssl/certs/ca.crt (mounted from headlamp-tls secret)

## Debugging Commands
```bash
# Check Headlamp logs (filter out noise)
k3s kubectl logs -n headlamp -l app.kubernetes.io/name=headlamp --tail=100 | grep -v "refreshing token\|Request completed"

# Check Keycloak auth errors
k3s kubectl logs -n keycloak -l app=keycloak --tail=50 | grep -iE "error|warn|invalid|login"

# Clear all Keycloak sessions
TOKEN=$(curl -sk -X POST "https://152.53.135.19/keycloak/realms/master/protocol/openid-connect/token" -d "username=admin&password=admin&grant_type=password&client_id=admin-cli" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
curl -sk -X POST -H "Authorization: Bearer $TOKEN" "https://152.53.135.19/keycloak/admin/realms/headlamp/logout-all"

# Restart Headlamp
k3s kubectl rollout restart deployment headlamp -n headlamp

# Test token exchange from Headlamp pod
POD=$(k3s kubectl get pods -n headlamp -l app.kubernetes.io/name=headlamp -o jsonpath="{.items[0].metadata.name}")
k3s kubectl exec -n headlamp $POD -- wget -q -O- --no-check-certificate "https://152.53.135.19/keycloak/realms/headlamp/protocol/openid-connect/token" --post-data="grant_type=password&client_id=headlamp&client_secret=headlamp-client-secret&username=admin&password=admin&scope=openid"
```

## Next Steps To Investigate
1. Watch Headlamp logs IN REAL TIME during a fresh login attempt from incognito - look for auth callback handling, token exchange errors
2. Check if Headlamp's OIDC callback URL matches what Keycloak redirects to
3. Consider the `directAccessGrantsEnabled` setting - may need to be disabled if it interferes
4. Check if the `usePKCE: true` in Headlamp is actually sending the code_challenge in the authorization request (inspect browser network tab)
5. Possible that Headlamp's internal session store doesn't persist the auth code state between redirect