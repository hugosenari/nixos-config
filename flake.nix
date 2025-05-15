{
  description     = "Hugosenari Hosts";

  inputs.prev.url = "github:NixOS/nixpkgs/release-24.05";
  inputs.next.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.curr.url = "github:NixOS/nixpkgs/release-24.11";
  inputs.homa.url = "github:nix-community/home-manager/release-24.05";
  inputs.homa.inputs.nixpkgs.follows = "prev";

  outputs = inputs: rec {
    nixosModules.ME.imports = [ ./hugosenari ];
    nixosModules.OS.imports = [ ./cfg.nix ./cache ./networking.nix ];
    nixosModules.BO.imports = [ nixosModules.OS nixosModules.ME ./bo ];
    nixosModules.HP.imports = [ nixosModules.OS nixosModules.ME ./hp ];
    nixosModules.T1.imports = [ nixosModules.OS nixosModules.ME ./t1 ];

    nixosConfigurations.BO  = lib.prevOS nixosModules.BO;
    nixosConfigurations.HP  = lib.prevOS nixosModules.HP;
    nixosConfigurations.T1  = lib.prevOS nixosModules.T1;

    lib.prevOS = lib.os inputs.prev;
    lib.currOS = lib.os inputs.curr;
    lib.nextOS = lib.os inputs.next;

    lib.os = nixpkgs: cfg: nixpkgs.lib.nixosSystem {
      modules = [ inputs.homa.nixosModules.home-manager cfg ];
      system  = "x86_64-linux";
      specialArgs.inputs = inputs // { nixpkgs = nixpkgs; };
    };
  };
}
