{
  description     = "Hugosenari Hosts";

  inputs."v25_11".url = "github:NixOS/nixpkgs";
  inputs."h25_11".url = "github:nix-community/home-manager";
  inputs."h25_11".inputs.nixpkgs.follows = "v25_11";
  inputs.envoluntary.url = "github:dfrankland/envoluntary";
  inputs.envoluntary.inputs.nixpkgs.follows = "v25_11";
  inputs.envoluntary.inputs.home-manager.follows = "h25_11";

  outputs = inputs: rec {
    # evoluntary modules
    homeModules.envoluntary.imports   = [ 
      inputs.envoluntary.homeModules.default
      ({pkgs, ...}: { programs.envoluntary.package = inputs.envoluntary.packages.${pkgs.system}.default; })
    ];
    nixosModules.envoluntary.imports = [
      inputs.envoluntary.nixosModules.default
      ({pkgs, ...}: { programs.envoluntary.package = inputs.envoluntary.packages.${pkgs.system}.default; })
    ];

    # user home-manager cfg

    homeModules.I.imports   = [ ./hugosenari/home-manager homeModules.envoluntary ];
    homeModules.D.imports   = [ homeModules.I ./hugosenari/home-manager/desktop.nix ];

    # user cfg
    nixosModules.me.imports = [ ./hugosenari ];

    # nixos cfg
    nixosModules.os.imports = [ ./base.nix ./networking.nix ./nix.nix ];

    # nixos desktop cfg
    nixosModules.de.imports = [ ./desktop.nix ];

    # nixos machines cfg
    nixosModules.t1.imports = [ nixosModules.os nixosModules.me ./t1 nixosModules.de ];
    
    # nixos machines entry points (used by nixos-rebuild command)
    nixosConfigurations.t1  = lib.os "25_11" nixosModules.t1 homeModules.D;

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
