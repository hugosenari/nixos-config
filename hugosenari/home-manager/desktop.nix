{ pkgs, ...}:
{
  imports = [ ./espanso.nix ];
  xdg.enable = true;
  programs.gnome-shell.enable   = true;
  programs.gnome-shell.extensions = [
    { package = pkgs.gnomeExtensions.pano; }
    { package = pkgs.gnomeExtensions.gsconnect; }
    { package = pkgs.gnomeExtensions.nasa-apod; }
  ];
  home.packages = [
    pkgs.keybase-gui
    pkgs.telegram-desktop
    pkgs.xclip
  ]; 
}
