{ pkgs, ...}: {
  imports = [ ./hardware.nix ./tpm2-emo.nix ];

  networking.hostName = "hp"; # Define your hostname.
  users.users.hugosenari.isNormalUser = true;
  users.users.hugosenari.description  = "hugosenari";
  users.users.hugosenari.extraGroups  = [ "networkmanager" "wheel" ];
  security.sudo.wheelNeedsPassword = false;
  nix.sshServe.enable = true;
  nix.sshServe.write = true;
  nix.sshServe.trusted = true;
  nix.sshServe.protocol = "ssh-ng";
}
