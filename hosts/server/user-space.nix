{ pkgs, ... }: {
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.openssh.enable = true;
	services.onedrive.enable = false;

  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = true;

  services.xrdp = {
    enable = true;
    defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
    openFirewall = true;
  };
  environment.etc."xrdp/startwm.sh".source = pkgs.writeScript "startwm.sh" ''
    #!/bin/sh
    if [ -z "$XDG_RUNTIME_DIR" ]; then
      export XDG_RUNTIME_DIR="/run/user/$(id -u)"
    fi
    export XDG_SESSION_TYPE=x11
    export XDG_CURRENT_DESKTOP=GNOME
    export GDK_BACKEND=x11
    export LIBGL_ALWAYS_SOFTWARE=1
    export GNOME_DESKTOP_SESSION_ID=1
    exec ${pkgs.gnome-session}/bin/gnome-session
  '';
  services.libinput.enable = true;
  programs.zsh.enable = true;
}
