{
  inputs.nixpkgs.url      = "github:NixOs/nixpkgs/nixos-22.05";
  # inputs.nixpkgs.url      = "github:NixOs/nixpkgs";  # unstable branch
  inputs.home-manager.url = "github:nix-community/home-manager/master";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs: 
  let mkOS = modules: inputs.nixpkgs.lib.nixosSystem {
    modules     = [ inputs.home-manager.nixosModules.home-manager ] ++ modules;
    specialArgs = { inherit inputs; };
    system      = "x86_64-linux";
  };
  in {
    nixosConfigurations.HP = mkOS [ ./cfg.nix ./hp ./hugosenari ./networking.nix ];
    nixosConfigurations.T1 = mkOS [ ./cfg.nix ./t1 ./hugosenari ./networking.nix ];
  };
}
