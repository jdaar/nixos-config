{ inputs, ... }: {
  users.users.jhonatan.isNormalUser = true;
  users.users.jhonatan.extraGroups =
    [ "networkmanager" "wheel" "input" "uinput" ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
<<<<<<< HEAD
    users = { jhonatan = import ../../users/jhonatan.nix; };
=======
    users = { jhonatan = import ../../users/jhonatan.nix { keybinds = true; graphical = true; }; };
>>>>>>> 96458dd (chore: lint and nerdfonts)
  };
}
