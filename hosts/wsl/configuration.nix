{ inputs, ... }: {
  imports = [
    ./users.nix
    ./system.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];
}
