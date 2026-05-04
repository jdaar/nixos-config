{ pkgs, ... }:
let
  namespaceYaml = pkgs.writeText "namespace.yaml" ''
    apiVersion: v1
    kind: Namespace
    metadata:
      name: projectcontour
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

  headlampRouteYaml = pkgs.writeText "headlamp-route.yaml" ''
    apiVersion: gateway.networking.k8s.io/v1
    kind: HTTPRoute
    metadata:
      name: headlamp
      namespace: headlamp
    spec:
      parentRefs:
        - name: contour
          namespace: projectcontour
      rules:
        - backendRefs:
            - name: headlamp
              port: 80
  '';

  gatewayClassYaml = pkgs.writeText "gateway-class.yaml" ''
    kind: GatewayClass
    apiVersion: gateway.networking.k8s.io/v1
    metadata:
      name: contour
    spec:
      controllerName: projectcontour.io/gateway-controller
  '';

  tlsSecretYaml = ./.tls/secret.yaml;

  gatewayYaml = pkgs.writeText "gateway.yaml" ''
    kind: Gateway
    apiVersion: gateway.networking.k8s.io/v1
    metadata:
      name: contour
      namespace: projectcontour
    spec:
      gatewayClassName: contour
      listeners:
        - name: http
          protocol: HTTP
          port: 80
          allowedRoutes:
            namespaces:
              from: All
        - name: https
          protocol: HTTPS
          port: 443
          tls:
            mode: Terminate
            certificateRefs:
              - name: contour-tls
                namespace: projectcontour
          allowedRoutes:
            namespaces:
              from: All
  '';

  contourProvisionerYaml = pkgs.fetchurl {
    url = "https://projectcontour.io/quickstart/contour-gateway-provisioner.yaml";
    hash = "sha256-/re7fE+RxC9Urzn83u2zQoHNZA172ecAOOvIC9P/jGA=";
  };

  manifestDir = "/var/lib/rancher/k3s/server/manifests";
in
{
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = "--disable=traefik";
  };

  systemd.tmpfiles.rules = [
    "d ${manifestDir} 0755 root root -"
    "L+ ${manifestDir}/namespace.yaml - - - - ${namespaceYaml}"
    "L+ ${manifestDir}/headlamp-ns.yaml - - - - ${headlampNsYaml}"
    "L+ ${manifestDir}/headlamp-admin.yaml - - - - ${headlampAdminYaml}"
    "L+ ${manifestDir}/headlamp-admin-crb.yaml - - - - ${headlampAdminCrbYaml}"
    "L+ ${manifestDir}/headlamp.yaml - - - - ${headlampYaml}"
    "L+ ${manifestDir}/headlamp-route.yaml - - - - ${headlampRouteYaml}"
    "L+ ${manifestDir}/contour-gateway-provisioner.yaml - - - - ${contourProvisionerYaml}"
    "L+ ${manifestDir}/gateway-class.yaml - - - - ${gatewayClassYaml}"
    "L+ ${manifestDir}/gateway.yaml - - - - ${gatewayYaml}"
    "L+ ${manifestDir}/secret.yaml - - - - ${tlsSecretYaml}"
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
    contour
  ];
}