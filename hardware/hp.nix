{ config, lib, pkgs, modulesPath, ... }:
{
  imports     = [ "${modulesPath}/installer/scan/not-detected.nix" ];
  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  # Bootloader.
  boot.loader.grub.device      = "/dev/sda";
  boot.loader.grub.enable      = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.timeout = 1;
  boot.extraModulePackages = [ ];
  boot.kernelModules       = [ "kvm-intel" ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules          = [ ];

  # Configure console keymap
  console.keyMap = "br-abnt2";

  fileSystems."/".device     = "/dev/disk/by-uuid/2e3f2881-873c-4855-8847-6d9ce6c6ecf3";
  fileSystems."/".fsType     = "ext4";
  fileSystems."/home".device = "/dev/disk/by-uuid/35f101c7-12cb-426c-af91-23b82ec9871e";
  fileSystems."/home".fsType = "ext4";

  networking.hostName = "HP";
  networking.useDHCP  = lib.mkDefault true;
  # networking.interfaces.enp0s26u1u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP      = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP      = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.synergy.client.autoStart     = true;
  services.synergy.client.enable        = true;
  services.synergy.client.screenName    = "hp";
  services.synergy.client.serverAddress = "t1.lilasp";
}
