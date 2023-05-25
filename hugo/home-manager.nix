{ config, pkgs, lib, ... }:
{
  imports = [ ./git.nix ./nvim.nix ./kbpass.nix ./espanso.nix ];

  home.stateVersion  = "22.11";
  home.packages      = [
    pkgs.chromium
    pkgs.keybase-gui
    pkgs.openconnect
    pkgs.tdesktop
    pkgs.xclip
  ]; 
  home.sessionVariables.EDITOR       = "vim";
  nix.extraOptions = ''
    !include ${config.home.homeDirectory}/keybase/private/hugosenari/nix.conf
  '';

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
  programs.nushell.enable            = true;
  programs.nushell.envFile.source    = ./env.nu;
  programs.password-store.enable     = true;
  programs.ssh.enable                = true;
  programs.ssh.compression           = true;
  programs.ssh.controlMaster         = "auto";
  programs.ssh.controlPath           = "/tmp/ssh-%r@%h:%p";
  programs.ssh.controlPersist        = "1h";
  programs.ssh.extraConfig           = ''
    IdentityFile %h/keybase/private/hugosenari/ssh/id_rsa
    IdentityFile %h/keybase/private/hugosenari/ssh/id_rsa_altice
    IdentityFile %h/keybase/private/hugosenari/ssh/id_ed25519
    IdentityFile %h/keybase/private/hugosenari/ssh/google_compute_engine
  '';

  services.kbfs.enable               = true;
  services.keybase.enable            = true;
  xdg.enable = true;
}
