{ pkgs, ... }:
let
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

  cleanupScript = pkgs.writeShellScript "k3s-cleanup" ''
    export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

    until ${pkgs.k3s}/bin/kubectl get nodes 2>/dev/null; do
      sleep 2
    done

    staleManifests=(
      namespace.yaml
      headlamp-route.yaml
      contour-gateway-provisioner.yaml
      gateway-class.yaml
      gateway.yaml
      secret.yaml
    )
    for m in "''${staleManifests[@]}"; do
      rm -f ${manifestDir}/$m
    done

    ${pkgs.k3s}/bin/kubectl delete httproute headlamp -n headlamp --ignore-not-found
    ${pkgs.k3s}/bin/kubectl delete gateway contour -n projectcontour --ignore-not-found
    ${pkgs.k3s}/bin/kubectl delete gatewayclass contour --ignore-not-found
    ${pkgs.k3s}/bin/kubectl delete namespace projectcontour --ignore-not-found
    ${pkgs.k3s}/bin/kubectl delete secret contour-tls -n projectcontour --ignore-not-found
    ${pkgs.k3s}/bin/kubectl delete secret headlamp-tls -n headlamp --ignore-not-found

    crds=(
      backendtlspolicies.gateway.networking.k8s.io
      contourconfigurations.projectcontour.io
      contourdeployments.projectcontour.io
      extensionservices.projectcontour.io
      gatewayclasses.gateway.networking.k8s.io
      gateways.gateway.networking.k8s.io
      grpcroutes.gateway.networking.k8s.io
      httpproxies.projectcontour.io
      httproutes.gateway.networking.k8s.io
      referencegrants.gateway.networking.k8s.io
      tcproutes.gateway.networking.k8s.io
      tlscertificatedelegations.projectcontour.io
      tlsroutes.gateway.networking.k8s.io
      udproutes.gateway.networking.k8s.io
      xbackendtrafficpolicies.gateway.networking.x-k8s.io
      xlistenersets.gateway.networking.x-k8s.io
    )
    for crd in "''${crds[@]}"; do
      ${pkgs.k3s}/bin/kubectl delete crd "$crd" --ignore-not-found
    done
  '';

  manifestDir = "/var/lib/rancher/k3s/server/manifests";
in
{
  services.k3s = {
    enable = true;
    role = "server";
  };

  systemd.services.k3s-cleanup = {
    description = "Clean up stale Contour/Gateway API resources";
    after = [ "k3s.service" ];
    wants = [ "k3s.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = cleanupScript;
      RemainAfterExit = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d ${manifestDir} 0755 root root -"
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
