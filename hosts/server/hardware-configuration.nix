{ lib, modulesPath, ... }:
{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];
 
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
 
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/bb456145-383b-48c6-8b5a-eeaa5a8a34dd";
      fsType = "ext4";
    };
 
  swapDevices =
    [ { device = "/dev/disk/by-uuid/6df4d78e-0088-4b02-9801-50bbf5e1a91f"; }
    ];
 
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

