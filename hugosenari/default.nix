{ pkgs, inputs, ... }: {
  home-manager.useGlobalPkgs          = true;
  home-manager.useUserPackages        = true;
  home-manager.users.hugosenari       = inputs.self.homeModules.I;
  users.users.hugosenari.description  = "hugosenari";
  users.users.hugosenari.extraGroups  = [ "networkmanager" "wheel" "sudo" "lp" "docker" "vboxusers" ];
  users.users.hugosenari.isNormalUser = true;
  users.users.hugosenari.shell        = pkgs.fish;
  programs.fish.enable                = true;
}
