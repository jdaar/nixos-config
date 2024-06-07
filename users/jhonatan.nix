{ keybinds, graphical }: { config, pkgs, lib, inputs, ... }:
let
  packages = with pkgs; (if graphical then
	  [
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
    []);
in
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.xremap-flake.homeManagerModules.default
    ./jhonatan/nvim.nix
		./jhonatan/dotfiles.nix
  ];

  services.xremap = lib.mkMerge [
	  (lib.mkIf keybinds {
	    enable = true;
	    yamlConfig = ''
	      keymap:
		- name: apps
		  remap:
		    Super-b:
		      launch: ["firefox"]
		    Super-t:
		      launch: ["alacritty"]
	    '';
	  })
	  (lib.mkIf (!keybinds) {
	    enable = false;
	  })
  ];

  home.username = "jhonatan";
  home.homeDirectory = "/home/jhonatan";
  home.packages = packages;

  home.stateVersion = "24.05";

  home.sessionVariables = { EDITOR = "nvim"; };
}
