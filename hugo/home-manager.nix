{ config, pkgs, lib, ... }:
let
  fish-completion-sync = {
    name = "fish-completion-sync";
    src  = pkgs.fetchFromGitHub {
      owner  = "pfgray";
      repo   = "fish-completion-sync";
      rev    = "ba70b6457228af520751eab48430b1b995e3e0e2";
      sha256 = "sha256-JdOLsZZ1VFRv7zA2i/QEZ1eovOym/Wccn0SJyhiP9hI=";
    };
  };
in
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
  programs.fish.plugins              = [ fish-completion-sync  ];
  programs.home-manager.enable       = true;
  programs.htop.enable               = true;
  programs.jq.enable                 = true;
  programs.mpv.enable                = true;
  programs.nushell.enable            = true;
  programs.nushell.envFile.source    = ./env.nu;
  programs.password-store.enable     = true;
  programs.ssh.enable                = true;
  programs.ssh.compression           = true;
  services.kbfs.enable               = true;
  services.keybase.enable            = true;
  xdg.enable = true;
}
