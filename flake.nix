{
  # inputs.nixpkgs.url      = "github:NixOs/nixpkgs/nixos-22.05";
  inputs.nixpkgs.url      = "github:NixOs/nixpkgs";  # unstable branch
  inputs.home-manager.url = "github:nix-community/home-manager/master";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs: 
  let 
    mkOS  = modules: inputs.nixpkgs.lib.nixosSystem {
      modules     = [ inputs.home-manager.nixosModules.home-manager ] ++ modules;
      specialArgs = { inherit inputs; };
      system      = "x86_64-linux";
    };
    mkHM  = modules: inputs.home-manager.lib.homeManagerConfiguration {
      inherit modules;
    };
    mapHM = builtins.mapAttrs (user: modules: mkHM modules);
  in {
    nixosConfigurations.HP = mkOS [ ./cfg.nix ./hp ./hugosenari ./networking.nix ];
    nixosConfigurations.T1 = mkOS [ ./cfg.nix ./t1 ./hugosenari ./networking.nix ];
    homeConfigurations = mapHM {
      "hugo.s.ribeiro@wpteng279" = [ ./hugo.s.ribeiro/hugo.s.ribeiro.nix ];
    };
  };
}
