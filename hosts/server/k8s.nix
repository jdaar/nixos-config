{ pkgs, ... }:
let
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

  tlsSecretYaml = ./.tls/secret.yaml;

  manifestDir = "/var/lib/rancher/k3s/server/manifests";
in
{
  services.k3s = {
    enable = true;
    role = "server";
  };

  systemd.tmpfiles.rules = [
    "d ${manifestDir} 0755 root root -"
    "L+ ${manifestDir}/headlamp-ns.yaml - - - - ${headlampNsYaml}"
    "L+ ${manifestDir}/headlamp-admin.yaml - - - - ${headlampAdminYaml}"
    "L+ ${manifestDir}/headlamp-admin-crb.yaml - - - - ${headlampAdminCrbYaml}"
    "L+ ${manifestDir}/headlamp.yaml - - - - ${headlampYaml}"
    "L+ ${manifestDir}/headlamp-ingress.yaml - - - - ${headlampIngressYaml}"
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
  ];
}
