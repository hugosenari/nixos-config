# One Netbook T1
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];     

  swapDevices = [ ];

  networking.hostName = "T1";
  networking.useDHCP  = lib.mkDefault true;

  boot.kernelModules  = [ "kvm-intel" ];
  boot.initrd.availableKernelModules   = [ "xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint     = "/boot";
  boot.loader.systemd-boot.enable      = true;
  fileSystems."/".device               = "/dev/disk/by-label/nixos";
  fileSystems."/".fsType               = "ext4";
  fileSystems."/boot".device           = "/dev/disk/by-label/EFI";
  fileSystems."/boot".fsType           = "vfat";
  fileSystems."/home".device           = "/dev/disk/by-label/home";
  fileSystems."/home".fsType           = "ext4";

  powerManagement.cpuFreqGovernor    = "powersave";
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
  hardware.bluetooth.enable          = true;
}
