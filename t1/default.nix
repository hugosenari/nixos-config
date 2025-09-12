{
  imports = [
    ./hardware.nix
    ./synergy.nix
  ];

  system.stateVersion = "25.05";
  services.xserver.desktopManager.enlightenment.enable = true;
  services.harmonia.signKeyPaths = [ "/etc/nix/t1.ka.gy.secret" ];
  nix.settings.substituters = [ "http://bo.ka.gy" ];
}
