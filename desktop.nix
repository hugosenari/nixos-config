{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.bluez
    pkgs.bluez-tools
    pkgs.firefox
    pkgs.meld
    pkgs.pulseaudio
  ];

  services.pulseaudio.enable = false;
  services.pipewire.enable     = true;
  services.pipewire.alsa.enable       = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable      = true;

  services.xserver.enable      = true;
  services.xserver.xkb.layout  = "br";
  services.xserver.xkb.options = "caps:swapescape";
  services.xserver.xkb.variant = "nodeadkeys";
  services.xserver.displayManager.gdm.enable   = true;
  services.xserver.displayManager.gdm.wayland  = false;
  services.xserver.desktopManager.gnome.enable = true;
}   
