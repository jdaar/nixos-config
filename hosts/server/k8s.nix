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
        service:
          type: NodePort
          nodePort: 30000
  '';

  gatewayClassYaml = pkgs.writeText "gateway-class.yaml" ''
    kind: GatewayClass
    apiVersion: gateway.networking.k8s.io/v1
    metadata:
      name: contour
    spec:
      controllerName: projectcontour.io/gateway-controller
  '';

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
            mode: Passthrough
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
    "L+ ${manifestDir}/headlamp.yaml - - - - ${headlampYaml}"
    "L+ ${manifestDir}/contour-gateway-provisioner.yaml - - - - ${contourProvisionerYaml}"
    "L+ ${manifestDir}/gateway-class.yaml - - - - ${gatewayClassYaml}"
    "L+ ${manifestDir}/gateway.yaml - - - - ${gatewayYaml}"
  ];

  networking.firewall = {
    allowedTCPPorts = [
      6443
      10250
      2379
      2380
      80
      443
      30000
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