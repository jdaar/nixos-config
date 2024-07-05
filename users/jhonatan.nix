{ keybinds, graphical }:
{ pkgs, inputs, ... }:
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

      nerdfonts
    ] else
      []) ++ [
	
      ];
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.xremap-flake.homeManagerModules.default
    ./jhonatan/nvim.nix
    ./jhonatan/dotfiles.nix
  ];

  services.xremap = if keybinds then {
		enable = true;
		config = {
			keymap = [
				{
					name = "apps";
					remap = {
						super-b = {
							launch = ["firefox"];
						};
						super-t = {
							launch = ["alacritty"];
						};
					};
				}
			];
		};
	}
	else
	{ enable = false; };

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
