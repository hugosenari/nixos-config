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
  programs.gnome-shell.theme.name = "";
  programs.gnome-shell.theme.package = pkgs.plata-theme;
  home.packages = [
    pkgs.keybase-gui
    pkgs.telegram-desktop
    pkgs.xclip
  ]; 
}
