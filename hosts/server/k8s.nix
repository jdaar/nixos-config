{ pkgs, lib, ... }:
let
  manifestsDir = "rancher/k3s/server/manifests";
in
{
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = "--disable=traefik";
  };

  environment.etc = lib.mapAttrs' (name: _: {
    name = "${manifestsDir}/${name}";
    value = { source = ./k8s/${name}; };
  }) (builtins.readDir ./k8s);

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