{
  description     = "Hugosenari Hosts";

  inputs.v2405.url = "github:NixOS/nixpkgs/release-24.05";
  inputs.v2411.url = "github:NixOS/nixpkgs/release-24.11";
  inputs.v2505.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.homa.url = "github:nix-community/home-manager/release-24.05";
  inputs.homa.inputs.nixpkgs.follows = "v2405";

  outputs = {v2405, v2411, ...}@inputs: rec {
    homeModules.I.imports   = [ ./hugosenari/home-manager.nix ];
    nixosModules.ME.imports = [ ./hugosenari ];
    nixosModules.OS.imports = [ ./cfg.nix ./cache ./networking.nix ];
    nixosModules.BO.imports = [ nixosModules.OS nixosModules.ME ./bo ];
    nixosModules.T1.imports = [ nixosModules.OS nixosModules.ME ./t1 ];

    nixosConfigurations.BO  = lib.os v2405 nixosModules.BO;
    nixosConfigurations.T1  = lib.os v2411 nixosModules.T1;

    lib.os = nixpkgs: cfg: nixpkgs.lib.nixosSystem {
      modules = [ inputs.homa.nixosModules.home-manager cfg ];
      system  = "x86_64-linux";
      specialArgs.inputs = inputs // { nixpkgs = nixpkgs; };
    };
  };
}
