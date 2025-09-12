{
  imports = [
    ./hardware.nix
    ./synergy.nix
  ];

  system.stateVersion = "24.11";
  services.xserver.desktopManager.enlightenment.enable = true;
  services.harmonia.signKeyPaths = [ "/etc/nix/bo.ka.gy.secret" ];
  nix.settings.substituters = [ "t1.ka.gy" ];
}
