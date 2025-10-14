{ pkgs, ...}: {
  imports = [ ./hardware.nix ];

  networking.hostName = "hp"; # Define your hostname.
  users.users.hugosenari.isNormalUser = true;
  users.users.hugosenari.description  = "hugosenari";
  users.users.hugosenari.extraGroups  = [ "networkmanager" "wheel" ];
  services.harmonia.signKeyPaths = [ "/etc/nix/hp.ka.gy.secret" ];
  security.sudo.wheelNeedsPassword = false;
}
