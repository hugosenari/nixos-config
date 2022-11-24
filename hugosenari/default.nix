{ pkgs, ... }: {
  home-manager.useGlobalPkgs          = true;
  home-manager.useUserPackages        = true;
  home-manager.users.hugosenari       = import ./home-manager.nix;
  users.users.hugosenari.description  = "hugosenari";
  users.users.hugosenari.extraGroups  = [ "networkmanager" "wheel" "sudo" "lp" "docker" ];
  users.users.hugosenari.isNormalUser = true;
  users.users.hugosenari.shell        = pkgs.fish;
}
