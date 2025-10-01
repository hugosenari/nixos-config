{
  imports = [
    ./hardware.nix
    ./synergy.nix
  ];

  services.harmonia.signKeyPaths = [ "/etc/nix/t1.ka.gy.secret" ];
  nix.settings.substituters = [ "http://bo.ka.gy:5000" ];
}
