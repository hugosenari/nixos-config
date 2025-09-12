{
  description     = "Hugosenari Hosts";

  inputs.v2411.url = "github:NixOS/nixpkgs/release-24.11";
  inputs.v2505.url = "github:NixOS/nixpkgs/release-25.05";
  inputs.h2411.url = "github:nix-community/home-manager/release-24.11";
  inputs.h2505.url = "github:nix-community/home-manager/release-24.05";
  inputs.h2411.inputs.nixpkgs.follows = "v2411";
  inputs.h2505.inputs.nixpkgs.follows = "v2505";

  outputs = {v2411, v2505, h2411, h2505, ...}@inputs: rec {
    homeModules.I.imports   = [ ./hugosenari/home-manager.nix ];
    nixosModules.me.imports = [ ./hugosenari ];
    nixosModules.os.imports = [ ./cfg.nix ./networking.nix ];
    nixosModules.bo.imports = [ nixosModules.os nixosModules.me ./bo ];
    nixosModules.t1.imports = [ nixosModules.os nixosModules.me ./t1 ];

    nixosConfigurations.bo  = lib.os v2411 h2411 nixosModules.bo;
    nixosConfigurations.t1  = lib.os v2505 h2505 nixosModules.t1;

    lib.os = nixpkgs: homa: cfg: nixpkgs.lib.nixosSystem {
      modules = [ homa.nixosModules.home-manager cfg ];
      system  = "x86_64-linux";
      specialArgs.inputs = inputs // { nixpkgs = nixpkgs; };
    };
  };
}
