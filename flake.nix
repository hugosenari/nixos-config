{
  description     = "Hugosenari Hosts";

  inputs.v2505.url = "github:NixOS/nixpkgs/release-25.05";
  inputs.h2505.url = "github:nix-community/home-manager/release-24.05";
  inputs.h2505.inputs.nixpkgs.follows = "v2505";

  outputs = {v2505, h2505, ...}@inputs: rec {
    homeModules.I.imports   = [ ./hugosenari/home-manager.nix ];
    nixosModules.me.imports = [ ./hugosenari ];
    nixosModules.os.imports = [ ./cfg.nix ./networking.nix ];
    nixosModules.bo.imports = [ nixosModules.os nixosModules.me ./bo ];
    nixosModules.t1.imports = [ nixosModules.os nixosModules.me ./t1 ];
    nixosModules.hp.imports = [ nixosModules.os nixosModules.me ./hp ];

    nixosConfigurations.bo  = lib.os "2505" nixosModules.bo;
    nixosConfigurations.t1  = lib.os "2505" nixosModules.t1;
    nixosConfigurations.hp  = lib.os "2505" nixosModules.hp;

    lib.os = version: cfg: inputs."v${version}".lib.nixosSystem {
      modules = [ inputs."h${version}".nixosModules.home-manager cfg ];
      system  = "x86_64-linux";
      specialArgs.inputs = inputs // { nixpkgs = inputs."v${version}"; };
    };
  };
}
