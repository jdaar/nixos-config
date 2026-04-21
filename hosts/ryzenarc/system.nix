{ pkgs, config, ... }: {
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  boot.loader = {
    grub.enable = false;
    refind = {
      enable = true;
      extraConfig = ''
        timeout 15
        default_selection 2
	      enable_mouse
      '';
    };
    efi.canTouchEfiVariables = true;
  };

  hardware.uinput.enable = true;

  nix.settings.experimental-features = "nix-command flakes";
  virtualisation.waydroid.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    zellij
    appimage-run
    fzf
    zip
    unzip
    git

    # GNU
    coreutils-prefixed
    gcc
    gnumake

    # Monitoring
    nvtopPackages.nvidia
    htop
    lshw
  ];

  networking.hostName = "ryzen-3400g-intel-arc";
  networking.wireless.enable = true;  
  networking.networkmanager.enable = true;

  time.timeZone = "America/Bogota";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CO.UTF-8";
    LC_IDENTIFICATION = "es_CO.UTF-8";
    LC_MEASUREMENT = "es_CO.UTF-8";
    LC_MONETARY = "es_CO.UTF-8";
    LC_NAME = "es_CO.UTF-8";
    LC_NUMERIC = "es_CO.UTF-8";
    LC_PAPER = "es_CO.UTF-8";
    LC_TELEPHONE = "es_CO.UTF-8";
    LC_TIME = "es_CO.UTF-8";
  };

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "es";
    variant = "nodeadkeys";
  };

  console.keyMap = "es";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [  ];
  networking.firewall.allowedUDPPorts = [  ];
  networking.firewall.enable = true;

  system.stateVersion = "25.11";
}
