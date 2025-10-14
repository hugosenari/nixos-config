{ lib,  ... }:
{
  swapDevices = [ ];

  fileSystems."/".type       = "ext4";
  fileSystems."/".device     = "/dev/disk/by-uuid/2e3f2881-873c-4855-8847-6d9ce6c6ecf3";
  fileSystems."/home".type   = "ext4";
  fileSystems."/home".device = "/dev/disk/by-uuid/35f101c7-12cb-426c-af91-23b82ec9871e";

  boot.loader.grub.device   = "/dev/sda";
  boot.loader.grub.enable   = true;
  boot.kernelModules        = [ ];
  boot.extraModulePackages  = [ ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.availableKernelModules     = [ "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" ];

  hardware.cpu.intel.updateMicrocode     = true;
  services.logind.lidSwitchExternalPower = "ignore"; # do not suspend when lid close
  services.acpid.enable                  = true;     # bat, lid, etc info and commands
}
