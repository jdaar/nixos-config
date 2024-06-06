{ config, pkgs, ... }:

{
  home.username = "jhonatan";
  home.homeDirectory = "/home/jhonatan";

  home.stateVersion = "24.05"; 

  home.packages = with pkgs; [
    firefox
    neovim
    alacritty
    bitwarden
    spotify

    lutris-unwrapped
    webtorrent_desktop
    steam

    burpsuite
    wireshark

    gnomeExtensions.pop-shell
  ];

  home.file = {
    ".config/nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
