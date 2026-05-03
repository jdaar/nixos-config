{ pkgs, ... }: {
  nix.settings.experimental-features = "nix-command flakes";

	# use refind-install instead if mouse support is needed
  boot = {
		loader = {
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
		kernelPackages = pkgs.linuxPackages_latest;
	};


	virtualisation = {
		waydroid.enable = false;
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
    htop
    lshw
  ];

  networking.hostName = "server"; 
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

  system.stateVersion = "25.11";
}
