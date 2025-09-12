{ pkgs, inputs, ... }: {
  home-manager.useGlobalPkgs          = true;
  home-manager.useUserPackages        = true;
  home-manager.users.hugosenari       = inputs.self.homeModules.I;
  users.users.hugosenari.description  = "hugosenari";
  users.users.hugosenari.extraGroups  = [ "networkmanager" "wheel" "sudo" "lp" "docker" "vboxusers" "tss" ];
  users.users.hugosenari.isNormalUser = true;
  users.users.hugosenari.shell        = pkgs.fish;
  programs.fish.enable                = true;

  systemd.user.timers.id-ecdsa-signer.enable   = true;
  systemd.user.timers.id-ecdsa-signer.wantedBy = [ "timers.target" ];
  systemd.user.timers.id-ecdsa-signer.timerConfig.Unit            = "id-ecdsa-signer.service";
  systemd.user.timers.id-ecdsa-signer.timerConfig.OnBootSec       = "2m";
  systemd.user.timers.id-ecdsa-signer.timerConfig.OnUnitActiveSec = "2h";
  systemd.user.services.id-ecdsa-signer.serviceConfig.TimeoutStopSec = "90";
  systemd.user.services.id-ecdsa-signer.enable      = true;
  systemd.user.services.id-ecdsa-signer.description = "Sign id_ecdsa.pub every hour to keep it fresh";
  systemd.user.services.id-ecdsa-signer.wantedBy    = [ "multi-user.target" ];
  systemd.user.services.id-ecdsa-signer.serviceConfig.Type = "oneshot";
  systemd.user.services.id-ecdsa-signer.script = ''
    export LIBTMP2_PATH=${pkgs.tpm2-pkcs11}/lib/libtpm2_pkcs11.so
    export PATH=${pkgs.ssh-askpass-fullscreen}/bin:${pkgs.openssh}/bin:$PATH
    export SSH_ASKPASS=/home/hugosenari/.ssh/ask_p
    ssh-keygen \
      -s <(ssh-keygen -D $LIBTMP2_PATH) \
      -D $LIBTMP2_PATH \
      -V -2h:+2h \
      -I bo \
      -n $USER \
      -z 1 \
      /home/hugosenari/.ssh/id_ecdsa.pub
  '';
}
