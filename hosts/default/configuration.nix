{ inputs, config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
    ];

home-manager = {
useGlobalPkgs = true;
extraSpecialArgs = {inherit inputs;};
users = {
	jhonatan = import ../../users/jhonatan.nix;
};
};

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";

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

  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;
  system.stateVersion = "23.11";

  hardware.opengl = {
  	enable = true;
	driSupport = true;
	driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
  	modesetting.enable = true;
	powerManagement.enable = true;
	powerManagement.finegrained = false;
	open = false;
	nvidiaSettings = true;
	package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
	sync.enable = true;
  	intelBusId = "PCI:0:2:0";
	nvidiaBusId = "PCI:1:0:0";
  };

  nix.settings.experimental-features = "nix-command flakes";
  virtualisation.waydroid.enable = true;

  environment.systemPackages = with pkgs; [
	wget
	wineWowPackages.stable
	winetricks
	zellij
	appimage-run
	fzf
	zip
	unzip

	# GNU
	coreutils-prefixed
	gcc
	gnumake

	# Monitoring
  	nvtopPackages.nvidia
	htop
	lshw
  ];

	programs.zsh.enable = true;
	users.users.jhonatan.isNormalUser = true;
	users.users.jhonatan.extraGroups = [ "networkmanager" "wheel" ];
}
