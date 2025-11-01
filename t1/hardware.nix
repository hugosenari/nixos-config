# One Netbook T1
{
  networking.hostName = "t1";

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

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor    = "powersave";
  hardware.cpu.intel.updateMicrocode = true;
  hardware.bluetooth.enable          = true;
  hardware.enableRedistributableFirmware = true;
}
