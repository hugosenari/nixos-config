{ pkgs, ...}:
{
  imports = [ ./espanso.nix ];
  xdg.enable = true;
  programs.eclipse.enable       = true;
  programs.eclipse.enableLombok = true;
  programs.eclipse.package      = pkgs.eclipses.eclipse-jee;
  programs.gnome-shell.enable   = true;
  programs.gnome-shell.extensions = [
    { package = pkgs.gnomeExtensions.pano; }
    { package = pkgs.gnomeExtensions.gsconnect; }
    { package = pkgs.gnomeExtensions.nasa-apod; }
  ];
  home.packages = [
    pkgs.keybase-gui
    pkgs.tdesktop
    pkgs.xclip
  ]; 
}
