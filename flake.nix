{
  description         = "Hugosenari Hosts";

  inputs.nixpkgs.url  = "github:NixOS/nixpkgs/release-23.11";
  inputs.unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.unfree.url   = "github:numtide/nixpkgs-unfree";
  inputs.hm.url       = "github:nix-community/home-manager/master";
  inputs.hm.inputs.nixpkgs.follows = "unstable";

  outputs = inputs: rec {
    homeModules.I.imports   = [ ./hugosenari/home-manager.nix ];
    homeConfigurations.I    = lib.home homeModules.I;

    nixosModules.eu.imports = [ ./hugosenari/default.nix ];
    nixosModules.os.imports = [ ./cfg.nix ./cache ./networking.nix ];
    nixosModules.BO.imports = [ nixosModules.os nixosModules.eu ./bo ];
    nixosModules.HP.imports = [ nixosModules.os nixosModules.eu ./hp ];
    nixosModules.T1.imports = [ nixosModules.os nixosModules.eu ./t1 ];

    nixosConfigurations.BO  = lib.os nixosModules.BO;
    nixosConfigurations.HP  = lib.os nixosModules.HP;
    nixosConfigurations.T1  = lib.os nixosModules.T1;

    lib.os   = cfg: inputs.nixpkgs.lib.nixosSystem {
      modules = [ inputs.hm.nixosModules.home-manager cfg ];
      system  = "x86_64-linux";
      specialArgs.inputs = inputs;
      specialArgs.unfree = inputs.unfree.x86_64-linux;
    };

    lib.home = cfg: inputs.hm.lib.homeManagerConfiguration {
      modules = [ cfg ];
      pkgs    = inputs.unstable.legacyPackages.x86_64-linux;
      extraSpecialArgs.inputs = inputs;
      extraSpecialArgs.unfree = inputs.unfree.x86_64-linux;
    };
  };
}
