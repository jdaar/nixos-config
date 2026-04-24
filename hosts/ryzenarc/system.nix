{ pkgs, ... }: {
  nix.settings.experimental-features = "nix-command flakes";

	# use refind-install instead if mouse support is needed
  boot.loader = {
    grub.enable = false;
    refind = {
      enable = true;
      maxGenerations = 1;
      extraConfig = ''
        timeout 15
        default_selection 2
	      enable_mouse
      '';
    };
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

	virtualisation = {
		waydroid.enable = true;
		containers.enable = true;
		podman = {
			enable = true;
			dockerCompat = true;
			defaultNetwork.settings.dns_enabled = true;
		};
	};

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
    nvtopPackages.intel
    htop
    lshw
  ];

  networking.hostName = "ryzenarc"; 
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

  services.xserver.xkb = {
    layout = "es";
    variant = "nodeadkeys";
  };

  console.keyMap = "es";

  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.openssh.enable = true;
	
	services.onedrive.enable = true;

  networking.firewall.allowedTCPPorts = [  ];
  networking.firewall.allowedUDPPorts = [  ];
  networking.firewall.enable = true;

  system.stateVersion = "25.11";
}
