{ pkgs, ... }:
let
  namespaceYaml = pkgs.writeText "namespace.yaml" ''
    apiVersion: v1
    kind: Namespace
    metadata:
      name: projectcontour
  '';

  contourYaml = pkgs.writeText "contour.yaml" ''
    apiVersion: helm.cattle.io/v1
    kind: HelmChart
    metadata:
      name: contour
      namespace: kube-system
    spec:
      chart: contour
      repo: https://charts.bitnami.com/bitnami
      targetNamespace: projectcontour
      valuesContent: |
        contour:
          ingressController:
            enabled: true
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
      repo: https://kubernetes.github.io/headlamp
      targetNamespace: headlamp
      valuesContent: |
        service:
          type: NodePort
          nodePort: 30000
  '';

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
    "L+ ${manifestDir}/contour.yaml - - - - ${contourYaml}"
    "L+ ${manifestDir}/headlamp-ns.yaml - - - - ${headlampNsYaml}"
    "L+ ${manifestDir}/headlamp.yaml - - - - ${headlampYaml}"
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