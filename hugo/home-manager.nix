{ config, pkgs, lib, ... }:
let sources = import ./nix/sources.nix;
in
{
  imports = [ ../nixcfg.nix ./git.nix ./nvim.nix ];

  home.stateVersion  = "22.05";
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
  home.sessionVariables.EDITOR       = "vim";
  nixpkgs.config.allowUnfree         = true;
  nixpkgs.config.allowUnfreePredicate= (pkg: true);
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
