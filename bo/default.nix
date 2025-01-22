{
  imports = [
    ./hardware.nix
    ./synergy.nix
  ];

  virtualisation.virtualbox.host.enable = true;
  
}
