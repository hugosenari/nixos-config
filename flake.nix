{
  # inputs.nixpkgs.url      = "github:NixOs/nixpkgs/nixos-22.05";
  inputs.nixpkgs.url      = "github:NixOs/nixpkgs";  # unstable branch
  inputs.home-manager.url = "github:nix-community/home-manager/master";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs: 
  let
    system = "x86_64-linux";
    mkOS   = modules: inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules     = [ inputs.home-manager.nixosModules.home-manager ] ++ modules;
      specialArgs = { inherit inputs; };
    };
    mkHM   = modules: inputs.home-manager.lib.homeManagerConfiguration {
      inherit modules;
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    };
    mapHM  = builtins.mapAttrs (user: modules: mkHM modules);
  in {
    nixosConfigurations.HP = mkOS [ ./cfg.nix ./hp ./hugosenari ./networking.nix ];
    nixosConfigurations.T1 = mkOS [ ./cfg.nix ./t1 ./hugosenari ./networking.nix ];
    homeConfigurations = mapHM {
      "hugo.s.ribeiro@wpteng279" = [ ./hugo.s.ribeiro/home-manager.nix ];
    };
  };
}
