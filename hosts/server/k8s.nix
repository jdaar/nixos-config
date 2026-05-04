{ pkgs, ... }:
let
  keycloakNsYaml = pkgs.writeText "keycloak-ns.yaml" ''
    apiVersion: v1
    kind: Namespace
    metadata:
      name: keycloak
  '';

  keycloakRealmYaml = pkgs.writeText "keycloak-realm.yaml" ''
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: keycloak-realm
      namespace: keycloak
    data:
      headlamp-realm.json: |
        {
          "realm": "headlamp",
          "enabled": true,
          "sslRequired": "none",
          "registrationAllowed": false,
          "loginWithEmailAllowed": true,
          "duplicateEmailsAllowed": false,
          "resetPasswordAllowed": true,
          "editUsernameAllowed": true,
          "bruteForceProtected": true,
          "clients": [
            {
              "clientId": "headlamp",
              "enabled": true,
              "publicClient": false,
              "standardFlowEnabled": true,
              "directAccessGrantsEnabled": true,
              "redirectUris": [
                "https://152.53.135.19/oidc-callback"
              ],
              "webOrigins": [
                "https://152.53.135.19"
              ],
              "secret": "headlamp-client-secret",
              "attributes": {
                "pkce.code.challenge.method": "S256"
              }
            }
          ],
          "users": [
            {
              "username": "admin",
              "enabled": true,
              "email": "admin@headlamp.local",
              "firstName": "Admin",
              "lastName": "User",
              "credentials": [
                {
                  "type": "password",
                  "value": "admin",
                  "temporary": false
                }
              ],
              "realmRoles": ["admin", "default-roles-headlamp"]
            }
          ],
          "roles": {
            "realm": [
              {
                "name": "admin",
                "description": "Admin role"
              }
            ]
          }
        }
  '';

  keycloakPvcYaml = pkgs.writeText "keycloak-pvc.yaml" ''
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: keycloak-data
      namespace: keycloak
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi
  '';

  keycloakDeploymentYaml = pkgs.writeText "keycloak-deployment.yaml" ''
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: keycloak
      namespace: keycloak
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: keycloak
      template:
        metadata:
          labels:
            app: keycloak
        spec:
          containers:
            - name: keycloak
              image: quay.io/keycloak/keycloak:26.0
              args: ["start", "--import-realm", "--features=token-exchange"]
              env:
                - name: KC_HTTP_RELATIVE_PATH
                  value: /keycloak
                - name: KC_BOOTSTRAP_ADMIN_USERNAME
                  value: admin
                - name: KC_BOOTSTRAP_ADMIN_PASSWORD
                  value: admin
                - name: KC_HEALTH_ENABLED
                  value: "true"
                - name: KC_HTTP_ENABLED
                  value: "true"
                - name: KC_HOSTNAME
                  value: 152.53.135.19
                - name: KC_HOSTNAME_PATH
                  value: keycloak
                - name: KC_PROXY_HEADERS
                  value: xforwarded
                - name: KC_DB
                  value: postgres
                - name: KC_DB_URL
                  value: jdbc:postgresql://keycloak-db/keycloak
                - name: KC_DB_USERNAME
                  value: keycloak
                - name: KC_DB_PASSWORD
                  value: keycloak
              ports:
                - containerPort: 8080
                - containerPort: 9000
              readinessProbe:
                httpGet:
                  path: /keycloak/health/ready
                  port: 9000
                initialDelaySeconds: 30
                periodSeconds: 10
              livenessProbe:
                httpGet:
                  path: /keycloak/health/live
                  port: 9000
                initialDelaySeconds: 30
                periodSeconds: 10
              volumeMounts:
                - name: realm-import
                  mountPath: /opt/keycloak/data/import
          volumes:
            - name: realm-import
              configMap:
                name: keycloak-realm
  '';

  keycloakDbDeploymentYaml = pkgs.writeText "keycloak-db-deployment.yaml" ''
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: keycloak-db
      namespace: keycloak
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: keycloak-db
      template:
        metadata:
          labels:
            app: keycloak-db
        spec:
          containers:
            - name: postgres
              image: postgres:16
              env:
                - name: POSTGRES_DB
                  value: keycloak
                - name: POSTGRES_USER
                  value: keycloak
                - name: POSTGRES_PASSWORD
                  value: keycloak
              ports:
                - containerPort: 5432
              volumeMounts:
                - name: data
                  mountPath: /var/lib/postgresql/data
          volumes:
            - name: data
              persistentVolumeClaim:
                claimName: keycloak-data
  '';

  keycloakDbServiceYaml = pkgs.writeText "keycloak-db-service.yaml" ''
    apiVersion: v1
    kind: Service
    metadata:
      name: keycloak-db
      namespace: keycloak
    spec:
      ports:
        - port: 5432
          targetPort: 5432
      selector:
        app: keycloak-db
  '';

  keycloakServiceYaml = pkgs.writeText "keycloak-service.yaml" ''
    apiVersion: v1
    kind: Service
    metadata:
      name: keycloak
      namespace: keycloak
    spec:
      ports:
        - port: 8080
          targetPort: 8080
      selector:
        app: keycloak
  '';

  keycloakIngressYaml = pkgs.writeText "keycloak-ingress.yaml" ''
    apiVersion: traefik.io/v1alpha1
    kind: IngressRoute
    metadata:
      name: keycloak
      namespace: keycloak
    spec:
      entryPoints:
        - websecure
      routes:
        - match: PathPrefix(`/keycloak`)
          kind: Rule
          services:
            - name: keycloak
              port: 8080
      tls:
        secretName: headlamp-tls
  '';

  certManagerNsYaml = pkgs.writeText "cert-manager-ns.yaml" ''
    apiVersion: v1
    kind: Namespace
    metadata:
      name: cert-manager
  '';

  certManagerYaml = pkgs.writeText "cert-manager.yaml" ''
    apiVersion: helm.cattle.io/v1
    kind: HelmChart
    metadata:
      name: cert-manager
      namespace: kube-system
    spec:
      chart: cert-manager
      repo: https://charts.jetstack.io
      targetNamespace: cert-manager
      valuesContent: |
        crds:
          enabled: true
  '';

  clusterIssuerYaml = pkgs.writeText "cluster-issuer.yaml" ''
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: selfsigned
    spec:
      selfSigned: {}
  '';

  headlampNsYaml = pkgs.writeText "headlamp-ns.yaml" ''
    apiVersion: v1
    kind: Namespace
    metadata:
      name: headlamp
  '';

  headlampAdminYaml = pkgs.writeText "headlamp-admin.yaml" ''
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: headlamp-admin
      namespace: kube-system
  '';

  headlampAdminCrbYaml = pkgs.writeText "headlamp-admin-crb.yaml" ''
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: headlamp-admin-cluster-admin
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: cluster-admin
    subjects:
      - kind: ServiceAccount
        name: headlamp-admin
        namespace: kube-system
  '';

  headlampYaml = pkgs.writeText "headlamp.yaml" ''
    apiVersion: helm.cattle.io/v1
    kind: HelmChart
    metadata:
      name: headlamp
      namespace: kube-system
    spec:
      chart: headlamp
      repo: https://kubernetes-sigs.github.io/headlamp
      targetNamespace: headlamp
      valuesContent: |
        config:
          oidc:
            clientID: headlamp
            clientSecret: headlamp-client-secret
            issuerURL: http://keycloak.keycloak:8080/keycloak/realms/headlamp
            scopes: openid profile email
  '';

  headlampCertYaml = pkgs.writeText "headlamp-cert.yaml" ''
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: headlamp
      namespace: headlamp
    spec:
      secretName: headlamp-tls
      duration: 2160h
      renewBefore: 360h
      issuerRef:
        name: selfsigned
        kind: ClusterIssuer
      ipAddresses:
        - 152.53.135.19
  '';

  headlampIngressYaml = pkgs.writeText "headlamp-ingress.yaml" ''
    apiVersion: traefik.io/v1alpha1
    kind: IngressRoute
    metadata:
      name: headlamp
      namespace: headlamp
    spec:
      entryPoints:
        - websecure
      routes:
        - match: PathPrefix(`/`)
          kind: Rule
          services:
            - name: headlamp
              port: 80
      tls:
        secretName: headlamp-tls
  '';

  manifestDir = "/var/lib/rancher/k3s/server/manifests";
in
{
  services.k3s = {
    enable = true;
    role = "server";
  };

  systemd.tmpfiles.rules = [
    "d ${manifestDir} 0755 root root -"
    "L+ ${manifestDir}/keycloak-ns.yaml - - - - ${keycloakNsYaml}"
    "L+ ${manifestDir}/keycloak-realm.yaml - - - - ${keycloakRealmYaml}"
    "L+ ${manifestDir}/keycloak-pvc.yaml - - - - ${keycloakPvcYaml}"
    "L+ ${manifestDir}/keycloak-db-deployment.yaml - - - - ${keycloakDbDeploymentYaml}"
    "L+ ${manifestDir}/keycloak-db-service.yaml - - - - ${keycloakDbServiceYaml}"
    "L+ ${manifestDir}/keycloak-deployment.yaml - - - - ${keycloakDeploymentYaml}"
    "L+ ${manifestDir}/keycloak-service.yaml - - - - ${keycloakServiceYaml}"
    "L+ ${manifestDir}/keycloak-ingress.yaml - - - - ${keycloakIngressYaml}"
    "L+ ${manifestDir}/cert-manager-ns.yaml - - - - ${certManagerNsYaml}"
    "L+ ${manifestDir}/cert-manager.yaml - - - - ${certManagerYaml}"
    "L+ ${manifestDir}/cluster-issuer.yaml - - - - ${clusterIssuerYaml}"
    "L+ ${manifestDir}/headlamp-ns.yaml - - - - ${headlampNsYaml}"
    "L+ ${manifestDir}/headlamp-admin.yaml - - - - ${headlampAdminYaml}"
    "L+ ${manifestDir}/headlamp-admin-crb.yaml - - - - ${headlampAdminCrbYaml}"
    "L+ ${manifestDir}/headlamp.yaml - - - - ${headlampYaml}"
    "L+ ${manifestDir}/headlamp-cert.yaml - - - - ${headlampCertYaml}"
    "L+ ${manifestDir}/headlamp-ingress.yaml - - - - ${headlampIngressYaml}"
  ];

  networking.firewall = {
    allowedTCPPorts = [
      6443
      10250
      2379
      2380
      80
      443
    ];
    allowedUDPPorts = [ 8472 ];
  };

  environment.systemPackages = with pkgs; [
    kubernetes-helm
    kubectl
    k3s
  ];
}
