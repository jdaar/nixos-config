{ pkgs, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = "--disable=traefik";
    manifests = {
      namespace = {
        enable = true;
        content = {
          apiVersion = "v1";
          kind = "Namespace";
          metadata = {
            name = "projectcontour";
          };
        };
      };
      contour = {
        enable = true;
        content = {
          apiVersion = "helm.cattle.io/v1";
          kind = "HelmChart";
          metadata = {
            name = "contour";
            namespace = "kube-system";
          };
          spec = {
            chart = "contour";
            repo = "https://charts.bitnami.com/bitnami";
            targetNamespace = "projectcontour";
            valuesContent = "contour:\n  ingressController:\n    enabled: true\n";
          };
        };
      };
      headlamp = {
        enable = true;
        content = {
          apiVersion = "helm.cattle.io/v1";
          kind = "HelmChart";
          metadata = {
            name = "headlamp";
            namespace = "kube-system";
          };
          spec = {
            chart = "headlamp";
            repo = "https://kubernetes.github.io/headlamp";
            targetNamespace = "projectcontour";
            valuesContent = "service:\n  type: NodePort\n  nodePort: 30000\n";
          };
        };
      };
    };
  };

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