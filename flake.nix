{
  inputs.nixpkgs.url      = "github:NixOs/nixpkgs/nixos-22.05";
  # inputs.nixpkgs.url      = "github:NixOs/nixpkgs";
  inputs.home-manager.url = "github:nix-community/home-manager/master";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";


  outputs = inputs: {
    nixosConfigurations.HP = inputs.nixpkgs.lib.nixosSystem {
      system      = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules     = [
        ./hardware/hp.nix
        ./configuration.nix
        inputs.home-manager.nixosModules.home-manager
        ({ pkgs, ... }: {
          nix.registry.nixpkgs.flake = inputs.nixpkgs;
          home-manager.useGlobalPkgs    = true;
          home-manager.useUserPackages  = true;
          home-manager.users.hugosenari = import ./hugosenari/home.nix;
        })
      ];
    };
  };
}
