{ pkgs, lib, config, ...}:
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
  imports = [ ./git.nix ./nvim.nix ./kbpass.nix ];
  home.stateVersion  = "25.05";
  home.homeDirectory = "/home/hugosenari";
  home.username      = "hugosenari";
  home.packages      = [ pkgs.openconnect ]; 
  home.sessionVariables.EDITOR = "vim";
  nix.extraOptions = "\n!include ${config.home.homeDirectory}/keybase/private/hugosenari/nix.conf\n";
  nixpkgs.config.allowUnfree         = true;
  nixpkgs.config.allowUnfreePredicate= (pkg: true);
  programs.command-not-found.enable  = true;
  programs.direnv.enable             = true;
  programs.fish.enable               = true;
  programs.fish.plugins              = [ fish-completion-sync  ];
  programs.home-manager.enable       = true;
  programs.htop.enable               = true;
  programs.jq.enable                 = true;
  programs.nushell.enable            = true;
  programs.ssh.enable                = true;
  programs.ssh.compression           = true;
  services.kbfs.enable               = true;
  services.keybase.enable            = true;
}
