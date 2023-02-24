{
  imports = [
    ./hardware.nix
    ./synergy.nix
  ];
  services.connman.enable      = true;
  services.connman.enableVPN   = true;
}
