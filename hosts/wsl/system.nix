{ pkgs, ... }: {
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-wsl";

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

  services.xserver.enable = false;
  system.stateVersion = "23.11";

  nix.settings.experimental-features = "nix-command flakes";

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
}
