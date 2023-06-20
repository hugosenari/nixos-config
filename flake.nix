{
  description        = "Hugosenari Hosts";
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/master";
  inputs.unfree.url  = "github:numtide/nixpkgs-unfree";
  inputs.hm.url      = "github:nix-community/home-manager/master";
  inputs.hm.inputs.nixpkgs.follows = "nixpkgs";



  outputs = inputs: rec {
    lib = import ./lib.nix inputs "x86_64-linux";
    homeConfigurations.hugo = lib.home homeModules.hsr;
    homeModules.hsr.imports = [ ./hugosenari/home-manager.nix ];

    nixosConfigurations.BO  = lib.os nixosModules.BO;
    nixosConfigurations.HP  = lib.os nixosModules.HP;
    nixosConfigurations.T1  = lib.os nixosModules.T1;
    nixosModules.BO.imports = [ nixosModules.__ ./bo ];
    nixosModules.HP.imports = [ nixosModules.__ ./hp ];
    nixosModules.T1.imports = [ nixosModules.__ ./t1 ];
    nixosModules.__.imports = [ ./cfg.nix ./cache.nix ./hugosenari ./networking.nix ];
  };
}
