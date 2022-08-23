{ config, pkgs, lib, ... }:
let sources = import ./nix/sources.nix;
in
{
  imports = [ ./git.nix ./nvim.nix ];

  home.homeDirectory = "/home/hugosenari";
  home.packages      = [
    # (pkgs.callPackage (sources.funcoeszz + "/default.nix") {})
    # (pkgs.callPackage (sources.gmusicbrowser-nixpkgx + "/default.nix") {})
    pkgs.chromium
    pkgs.keybase-gui
    pkgs.openconnect
    pkgs.tdesktop
    pkgs.teams
    pkgs.xclip
  ]; 
  home.stateVersion  = "22.05";
  home.username      = "hugosenari";

  home.sessionVariables.EDITOR       = "vim";
  nixpkgs.config.allowUnfree         = true;
  programs.command-not-found.enable  = false;
  programs.direnv.enable             = true;
  programs.fish.enable               = true;
  programs.fzf.enable                = true;
  programs.fzf.enableFishIntegration = true;
  programs.home-manager.enable       = true;
  programs.htop.enable               = true;
  programs.jq.enable                 = true;
  programs.mpv.enable                = true;
  programs.password-store.enable     = true;
  services.kbfs.enable               = true;
  services.keybase.enable            = true;

  xdg.enable = true;
}
