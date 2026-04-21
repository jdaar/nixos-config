{ inputs, ... }: {
  users.users.jhonatan.isNormalUser = true;
  users.users.jhonatan.extraGroups =
    [ "networkmanager" "wheel" "input" "uinput" "nixconfig" ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      jhonatan = import ../../users/jhonatan.nix {
        keybinds = true;
        graphical = true;
      };
    };
  };
}
