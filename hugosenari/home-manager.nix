{ pkgs, ...}:
{
  imports = [ ../hugo/home-manager.nix ];
  home.homeDirectory = "/home/hugosenari";
  home.username      = "hugosenari";
  programs.eclipse.enableLombok = true;
  programs.eclipse.enable = true;
  programs.eclipse.package = pkgs.eclipses.eclipse-jee;
  programs.gnome-shell.enable = true;
  programs.gnome-shell.extensions = [
    { package = pkgs.gnomeExtensions.arrange-windows; }
    { package = pkgs.gnomeExtensions.pano; }
    { package = pkgs.gnomeExtensions.gsconnect; }
    { package = pkgs.gnomeExtensions.hydration-reminder; }
    { package = pkgs.gnomeExtensions.nasa-apod; }
    { package = pkgs.gnomeExtensions.wifi-qrcode; }
    { package = pkgs.gnomeExtensions.wiggle; }
  ];
}
