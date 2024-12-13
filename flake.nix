{
  description     = "Hugosenari Hosts";

  inputs.prev.url = "github:NixOS/nixpkgs/release-24.05";
  inputs.next.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.curr.url = "github:NixOS/nixpkgs/release-24.11";
  inputs.hm.url   = "github:nix-community/home-manager/release-24.05";
  inputs.hm.inputs.nixpkgs.follows = "prev";

  outputs = inputs: rec {
    homeModules.I.imports   = [ ./hugosenari/home-manager.nix ];
    homeConfigurations.I    = lib.home homeModules.I;

    nixosModules.I.imports  = [ ./hugosenari ];
    nixosModules.os.imports = [ ./cfg.nix ./cache ./networking.nix ];
    nixosModules.BO.imports = [ nixosModules.os nixosModules.I ./bo ];
    nixosModules.HP.imports = [ nixosModules.os nixosModules.I ./hp ];
    nixosModules.T1.imports = [ nixosModules.os nixosModules.I ./t1 ];

    nixosConfigurations.BO  = lib.prevOS nixosModules.BO;
    nixosConfigurations.HP  = lib.prevOS nixosModules.HP;
    nixosConfigurations.T1  = lib.prevOS nixosModules.T1;

    lib.prevOS = lib.os inputs.prev;
    lib.currOS = lib.os inputs.curr;
    lib.nextOS = lib.os inputs.next;
    lib.os = nixpkgs: cfg: nixpkgs.lib.nixosSystem {
      modules = [ inputs.hm.nixosModules.home-manager cfg ];
      system  = "x86_64-linux";
      specialArgs.inputs = inputs // { nixpkgs = nixpkgs; };
    };

    lib.home = nixpkgs: cfg: inputs.hm.lib.homeManagerConfiguration {
      modules = [ cfg ];
      pkgs    = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs.inputs = inputs // { nixpkgs = nixpkgs; };
    };
  };
}
