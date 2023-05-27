{
  description        = "Hugosenari Hosts";
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/master";
  inputs.unfree.url  = "github:numtide/nixpkgs-unfree";
  inputs.hm.url      = "github:nix-community/home-manager/master";
  inputs.hm.inputs.nixpkgs.follows = "nixpkgs";

  outputs = {self, hm, ...}@inputs:
  let
    mkOS = module: inputs.nixpkgs.lib.nixosSystem {
      modules     = [ module ];
      system      = "x86_64-linux";
      specialArgs.inputs = inputs;
      specialArgs.unfree = inputs.unfree.x86_64-linux;
    };
  in {
    nixosConfigurations.BO   = mkOS self.nixosModules.BO;
    nixosConfigurations.HP   = mkOS self.nixosModules.HP;
    nixosConfigurations.T1   = mkOS self.nixosModules.T1;
    nixosModules.ALL.imports = [ hm.nixosModules.home-manager ./cfg.nix ./cache.nix ./hugosenari ./networking.nix ];
    nixosModules.BO.imports  = [ self.nixosModules.ALL ./bo ];
    nixosModules.HP.imports  = [ self.nixosModules.ALL ./hp ];
    nixosModules.T1.imports  = [ self.nixosModules.ALL ./t1 ];
  };
}
