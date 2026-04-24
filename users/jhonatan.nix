{ keybinds, graphical }:
{ pkgs, inputs, ... }:
let
  packages =
    with pkgs;
    (
      if graphical then
        [
          firefox
          alacritty
          bitwarden-desktop
          spotify
          discord-ptb
          libreoffice-qt
          hyphenDicts.en_US

          lutris-unwrapped
          webtorrent_desktop
          steam

          burpsuite
          wireshark

          gnomeExtensions.pop-shell
          albert
          copyq

          nerd-fonts.go-mono

          podman
          rclone-ui
          rclone-browser
          syncthingtray
        ]
      else
        [ ]
    )
    ++ [
      claude-code
      copilot-cli
      podman-tui
      rclone
      syncthing
			lua51Packages.tree-sitter-cli
			ripgrep
			fd
    ];
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    inputs.xremap-flake.homeManagerModules.default
    ./jhonatan/nvim.nix
    ./jhonatan/dotfiles.nix
  ];

  services.xremap =
    if keybinds then
      {
        enable = true;
        config = {
          keymap = [
            {
              name = "apps";
              remap = {
                super-b = {
                  launch = [ "firefox" ];
                };
                super-t = {
                  launch = [ "alacritty" ];
                };
                super-space = {
                  launch = [
                    "albert"
                    "toggle"
                  ];
                };
              };
            }
          ];
        };
      }
    else
      { enable = false; };

  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };

  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      user = {
        name = "jhonatan";
        email = "jhonatandaar@gmail.com";
      };
    };
  };

  home.username = "jhonatan";
  home.homeDirectory = "/home/jhonatan";
  home.packages = packages;

  home.stateVersion = "24.05";

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
