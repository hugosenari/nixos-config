{
  imports = [
    ./hardware.nix
    ./synergy.nix
  ];
  nix.settings.substituters = [ "http://hp.ka.gy:5000" ];
}
