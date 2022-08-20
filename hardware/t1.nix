{ config, lib, pkgs, modulesPath, ... }:
{
  imports     = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  swapDevices = [ ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.extraModulePackages  = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules        = [ "kvm-intel" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint     = "/boot/efi";
  boot.loader.systemd-boot.enable      = true;

  fileSystems."/".device         = "/dev/disk/by-uuid/88ca8bba-0fc3-4fe8-bb7e-6e2548da988d";
  fileSystems."/".fsType         = "ext4";
  fileSystems."/boot/efi".device = "/dev/disk/by-uuid/9EC7-0DEC";
  fileSystems."/boot/efi".fsType = "vfat";

  networking.hostName = "T1";
  networking.useDHCP  = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
