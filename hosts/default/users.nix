{ inputs, ... }: {
  users.users.jhonatan.isNormalUser = true;
  users.users.jhonatan.extraGroups = [ "networkmanager" "wheel" ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { jhonatan = import ../../users/jhonatan.nix; };
  };
}
