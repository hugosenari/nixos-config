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
  systemd.user.services.kbfs.Service.PrivateTmp = lib.mkForce false; # KBFS fail with true
  systemd.user.services.id-ecdsa-signer.serviceConfig.TimeoutStopSec = "90";
  systemd.user.services.id-ecdsa-signer.enable      = true;
  systemd.user.services.id-ecdsa-signer.description = ''Resign id_ecdsa.pub to keep it fresh'';
  systemd.user.services.id-ecdsa-signer.wantedBy    = [ "multi-user.target" ];
  systemd.user.services.id-ecdsa-signer.serviceConfig.Type = "oneshot";
  systemd.user.services.id-ecdsa-signer.script = ''
    export LIBTMP2_PATH=/run/current-system/sw/lib/libtpm2_pkcs11.so
    export PATH=${pkgs.openssh}/bin:$PATH
    export SSH_ASKPASS=/home/hugosenari/.ssh/ask_p
    ssh-keygen \
      -s <(ssh-keygen -D $LIBTMP2_PATH) \
      -D $LIBTMP2_PATH \
      -V -2h:+2h \
      -I "$(hostname)" \
      -n $USER \
      -z 1 \
      /home/hugosenari/.ssh/id_ecdsa.pub
  '';
}
