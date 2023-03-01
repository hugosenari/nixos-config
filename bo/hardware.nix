{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  networking.hostName = "BO";
  networking.useDHCP  = lib.mkDefault true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules          = [ ];
  boot.kernelModules                 = [ "kvm-intel" ];
  boot.extraModulePackages           = [ ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint     = "/boot/efi";
  boot.loader.systemd-boot.enable      = true;

  fileSystems."/".device  = "/dev/disk/by-uuid/03da4575-a0f0-4cf9-a280-d388cb20de91";
  fileSystems."/".fsType  = "ext4";

  fileSystems."/boot/efi".device = "/dev/disk/by-uuid/B8F1-3F27";
  fileSystems."/boot/efi".fsType = "vfat";

  swapDevices = [ { device = "/dev/disk/by-uuid/75f343d8-d50c-4c54-bc2b-f91b6bcb2fae"; } ];

  powerManagement.cpuFreqGovernor    = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
