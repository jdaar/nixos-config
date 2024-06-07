{ config, pkgs, inputs, ... }:
let
  nvim-config = {
    enable = true;
    colorschemes.gruvbox.enable = true;
    plugins.lightline.enable = true;
  };
  packages = with pkgs; [
    firefox
    alacritty
    bitwarden
    spotify

    lutris-unwrapped
    webtorrent_desktop
    steam

    burpsuite
    wireshark

    gnomeExtensions.pop-shell
    home-manager
  ];
in {
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  home.username = "jhonatan";
  home.homeDirectory = "/home/jhonatan";

  home.stateVersion = "24.05";

  home.packages = packages;

  programs.nixvim = nvim-config;

  home.file = {
    ".config/nixpkgs/config.nix".source =
      ./jhonatan.dotfiles/nixpkgs/config.nix;
  };

  home.sessionVariables = { EDITOR = "nvim"; };
}
