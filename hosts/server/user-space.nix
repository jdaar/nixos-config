{ pkgs, ... }: {
  services.xserver.desktopManager.xfce.enable = true;

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
    defaultWindowManager = "${pkgs.xfce.xfce4-session}/bin/startxfce4";
    openFirewall = true;
  };
  services.libinput.enable = true;
  programs.zsh.enable = true;
}
