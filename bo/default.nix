{
  imports = [
    ./hardware.nix
    ./synergy.nix
  ];
  nix.settings.substituters = [ "ssh-ng://nix-ssh@hp.ka.gy?trusted=true&want-mass-query=true" ];
}
