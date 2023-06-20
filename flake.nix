{
  description        = "Hugosenari Hosts";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/master";
  inputs.unfree.url  = "github:numtide/nixpkgs-unfree";
  inputs.hm.url      = "github:nix-community/home-manager/master";
  inputs.hm.inputs.nixpkgs.follows = "nixpkgs";


  outputs = inputs: rec {
    lib = import ./lib.nix inputs "x86_64-linux";

    homeModules.eu.imports  = [ ./hugosenari/home-manager.nix ];
    homeConfigurations.eu   = lib.home homeModules.eu;

    nixosModules.eu.imports = [ ./hugosenari ];
    nixosModules.os.imports = [ ./cfg.nix ./cache.nix ./networking.nix ];
    nixosModules.BO.imports = [ nixosModules.os  nixosModules.eu  ./bo ];
    nixosModules.HP.imports = [ nixosModules.os  nixosModules.eu  ./hp ];
    nixosModules.T1.imports = [ nixosModules.os  nixosModules.eu  ./t1 ];

    nixosConfigurations.BO  = lib.os nixosModules.BO;
    nixosConfigurations.HP  = lib.os nixosModules.HP;
    nixosConfigurations.T1  = lib.os nixosModules.T1;
  };
}
