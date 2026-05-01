{ pkgs, ... }:
{
  imports = [ ./nix.desktop.nix ];
  environment.systemPackages = [
    pkgs.bluez
    pkgs.bluez-tools
    pkgs.firefox
    pkgs.meld
    pkgs.pulseaudio
    pkgs.enlightenment.terminology
  ];

  services.pulseaudio.enable = false;
  services.pipewire.enable     = true;
  services.pipewire.alsa.enable       = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable      = true;

  services.xserver.enable      = true;
  # services.xserver.xkb.layout  = "br";
  # services.xserver.xkb.options = "caps:swapescape";
  # services.xserver.xkb.variant = "nodeadkeys";

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
}   
