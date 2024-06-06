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

	# Gaming/pirating
	lutris-unwrapped
	webtorrent_desktop
	steam

	# Development
	burpsuite
	wireshark

	# Gnome extensions
	gnomeExtensions.pop-shell
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
