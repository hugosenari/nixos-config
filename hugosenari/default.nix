{ pkgs, inputs, ... }: {
  home-manager.useGlobalPkgs          = false;
  home-manager.useUserPackages        = false;
  home-manager.users.hugosenari       = inputs.self.homeModules.I;
  users.users.hugosenari.description  = "hugosenari";
  users.users.hugosenari.extraGroups  = [ "networkmanager" "wheel" "sudo" "lp" "docker" ];
  users.users.hugosenari.isNormalUser = true;
  users.users.hugosenari.shell        = pkgs.fish;
  programs.fish.enable                = true;
  # users.users.hugosenari.packages     = [ inputs.unfree.legacyPackages.x86_64-linux.teams ];
}
