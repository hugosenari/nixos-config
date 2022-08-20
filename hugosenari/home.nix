{ config, pkgs, lib, ... }:
let sources = import ./nix/sources.nix;
in
{
  imports = [ ./git.nix ./nvim.nix ];

  home.homeDirectory = "/home/hugosenari";
  home.packages      = [
    # (pkgs.callPackage (sources.funcoeszz + "/default.nix") {})
    # (pkgs.callPackage (sources.gmusicbrowser-nixpkgx + "/default.nix") {})
    # pkgs.slack
    # pkgs.vlc
    # pkgs.zoom-us
    pkgs.chromium
    pkgs.keybase-gui
    pkgs.tdesktop
    pkgs.teams
    pkgs.networkmanagerapplet
    pkgs.openconnect
    pkgs.xclip
  ]; 
  home.stateVersion  = "22.05";
  home.username      = "hugosenari";

  nixpkgs.config.allowUnfree = true;



  services.kbfs.enable    = true;
  services.keybase.enable = true;

  xdg.enable = true;
}
