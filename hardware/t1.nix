# One Netbook T1
{ config, lib, pkgs, modulesPath, ... }:
{
  imports     = [ "${modulesPath}/installer/scan/not-detected.nix" ];
  swapDevices = [ ];

  networking.hostName = "T1";
  networking.useDHCP  = lib.mkDefault true;

  boot.extraModulePackages  = [ ];
  boot.kernelParams         = [ "i915.enable_dpcd_backlight=1" "i915.force_probe=46a6" ];
  boot.kernelModules        = [ "kvm-intel" ];
  boot.initrd.availableKernelModules   = [ "xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules            = [ "i915" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint     = "/boot/efi";
  boot.loader.systemd-boot.enable      = true;
  fileSystems."/".device         = "/dev/nvme0n1p4";
  fileSystems."/".fsType         = "ext4";
  fileSystems."/boot/efi".device = "/dev/nvme0n1p1";
  fileSystems."/boot/efi".fsType = "vfat";

  environment.variables.VDPAU_DRIVER = "va_gl";
  powerManagement.cpuFreqGovernor    = "performance";
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
  hardware.bluetooth.enable          = true;
  hardware.opengl.enable             = true;
  hardware.opengl.extraPackages      = with pkgs; [vaapiIntel libvdpau-va-gl intel-media-driver];
  hardware.sensor.iio.enable         = true;
  services.udev.extraHwdb            = ''
    acpi:BOSC0200:BOSC0200:*
     ACCEL_MOUNT_MATRIX=0, 1, 0; 0, 0, 1; 1, 0, 0
  '';
  services.xserver.videoDrivers      = [ "intel" ];
}
