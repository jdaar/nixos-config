{ keybinds, graphical }:
{ config, pkgs, lib, inputs, ... }:
let
  packages = with pkgs;
    (if graphical then [
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
    ] else
      [ ]);
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.xremap-flake.homeManagerModules.default
    ./jhonatan/nvim.nix
    ./jhonatan/dotfiles.nix
  ];

  services.xremap = lib.mkMerge [
    (lib.mkIf keybinds {
      enable = true;
      yamlConfig =
        "      keymap:\n	- name: apps\n	  remap:\n	    Super-b:\n	      launch: [\"firefox\"]\n	    Super-t:\n	      launch: [\"alacritty\"]\n    ";
    })
    (lib.mkIf (!keybinds) { enable = false; })
  ];

  programs.git = {
    enable = true;
    userName = "jhonatan";
    userEmail = "jhonatandaar@gmail.com";
  };

  home.username = "jhonatan";
  home.homeDirectory = "/home/jhonatan";
  home.packages = packages;

  home.stateVersion = "24.05";

  home.sessionVariables = { EDITOR = "nvim"; };
}
