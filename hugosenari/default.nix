{ pkgs, inputs, ... }: {
  home-manager.useGlobalPkgs          = true;
  home-manager.useUserPackages        = true;
  home-manager.users.hugosenari       = inputs.self.homeModules.hsr;
  users.users.hugosenari.description  = "hugosenari";
  users.users.hugosenari.extraGroups  = [ "networkmanager" "wheel" "sudo" "lp" "docker" ];
  users.users.hugosenari.isNormalUser = true;
  users.users.hugosenari.shell        = pkgs.fish;
  programs.fish.enable                = true;
  # users.users.hugosenari.packages     = [ inputs.unfree.legacyPackages.x86_64-linux.teams ];
}
