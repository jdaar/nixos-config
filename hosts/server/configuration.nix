{ inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./disk.nix
      ./users.nix
      ./system.nix
      ./user-space.nix
      inputs.home-manager.nixosModules.home-manager
    ];
}
