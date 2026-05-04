{ inputs, ... }: {
  users.users.jhonatan.isNormalUser = true;
  users.users.jhonatan.hashedPassword = "$6$SvR2cW/PkEeUI1uO$sz.kpoeFKzZuprOnnQ7.7VeJY1eLyAWHisbWLIy0u2V64wmDOTsgtb0nKR5YS.htXKGQtBXgF5RL9n1z0Tmz80";
  users.users.jhonatan.extraGroups =
    [ "networkmanager" "wheel" "input" "uinput" "nixconfig" "podman" ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      jhonatan = import ../../users/jhonatan.nix {
        keybinds = true;
        graphical = true;
				isServer = true;
      };
    };
  };
}
