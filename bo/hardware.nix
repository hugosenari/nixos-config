{ config, lib, pkgs, modulesPath, ... }:
{
  imports     = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  boot.extraModulePackages           = [ ];
  boot.initrd.availableKernelModules = [ "ahci" "nvme" "usbhid" "sdhci_pci" ];
  boot.initrd.kernelModules          = [ ];
  boot.kernelModules                 = [ "kvm-intel" ];
  boot.loader.grub.enable            = false;
  console.keyMap                     = "br-abnt2";
  fileSystems."/".device             = "/dev/mapper/luks-a1894613-8663-4c32-a9db-a7be6879673b";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  networking.hostName                = "wpteng279";
  networking.useDHCP                 = lib.mkDefault true;
  powerManagement.cpuFreqGovernor    = lib.mkDefault "powersave";
  swapDevices                        = [ ];
}
