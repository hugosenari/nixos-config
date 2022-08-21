{
  inputs.nixpkgs.url      = "github:NixOs/nixpkgs/nixos-22.05";
  # inputs.nixpkgs.url      = "github:NixOs/nixpkgs";
  inputs.home-manager.url = "github:nix-community/home-manager/master";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";


  outputs = inputs: 
  let mkOS = hardware: inputs.nixpkgs.lib.nixosSystem {
      system      = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules     = hardware + [
        inputs.home-manager.nixosModules.home-manager
        ./cfg.nix
        ({ pkgs, ... }: {
          nix.registry.nixpkgs.flake    = inputs.nixpkgs;
          home-manager.useGlobalPkgs    = true;
          home-manager.useUserPackages  = true;
          home-manager.users.hugosenari = import ./hugosenari/home.nix;
        })
      ];
    }; 
  in
  {
    nixosConfigurations.HP = mkOS [ ./hardware/hp.nix ./synergy/hp.nix ];
    nixosConfigurations.T1 = mkOS [ ./hardware/t1.nix ./synergy/t1.nix ];
  };
}
