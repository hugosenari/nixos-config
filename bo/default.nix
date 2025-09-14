{
  imports = [
    ./hardware.nix
    ./synergy.nix
  ];


  services.harmonia.signKeyPaths = [ "/etc/nix/bo.ka.gy.secret" ];
  nix.settings.substituters = [ "http://t1.ka.gy:5000" ];
}
