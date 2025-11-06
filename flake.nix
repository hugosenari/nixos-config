{
  description     = "Hugosenari Hosts";

  inputs."v25_05".url = "github:NixOS/nixpkgs/release-25.05";
  inputs."h25_05".url = "github:nix-community/home-manager/release-25.05";
  inputs."h25_05".inputs.nixpkgs.follows = "v25_05";
  inputs.envoluntary.url = "github:dfrankland/envoluntary";
  inputs.envoluntary.inputs.nixpkgs.follows = "v25_05";
  inputs.envoluntary.inputs.home-manager.follows = "h25_05";

  outputs = inputs: rec {
    # user home-manager cfg
    homeModules.e.imports   = [ 
      inputs.envoluntary.homeModules.default
      { programs.envoluntary.package = inputs.envoluntary.packages.x86_64-linux.default; }
    ];
    homeModules.I.imports   = [ ./hugosenari/home-manager homeModules.e ];
    homeModules.D.imports   = [ homeModules.I ./hugosenari/home-manager/desktop.nix ];

    # user cfg
    nixosModules.me.imports = [ ./hugosenari ];

    # nixos cfg
    nixosModules.os.imports = [ ./base.nix ./networking.nix ./nix.nix ];

    # nixos desktop cfg
    nixosModules.de.imports = [ ./desktop.nix ];

    # nixos machines cfg
    nixosModules.hp.imports = [ nixosModules.os nixosModules.me ./hp ];
    nixosModules.bo.imports = [ nixosModules.os nixosModules.me ./bo nixosModules.de ];
    nixosModules.t1.imports = [ nixosModules.os nixosModules.me ./t1 nixosModules.de ];
    
    # nixos machines entry points (used by nixos-rebuild command)
    nixosConfigurations.hp  = lib.os "25_05" nixosModules.hp homeModules.I;
    nixosConfigurations.bo  = lib.os "25_05" nixosModules.bo homeModules.D;
    nixosConfigurations.t1  = lib.os "25_05" nixosModules.t1 homeModules.D;

    lib.os = version: cfg: hm-cfg: inputs."v${version}".lib.nixosSystem {
      system  = "x86_64-linux";
      specialArgs.inputs  = inputs;
      modules = [
        { system.stateVersion = builtins.replaceStrings ["_"] ["."] version; }
        cfg
      	inputs."h${version}".nixosModules.home-manager
        { home-manager.users.hugosenari = hm-cfg; }
      ];
    };
  };
}
