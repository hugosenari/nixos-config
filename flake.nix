{
  description             = "Hugosenari Hosts";
  #inputs.nixpkgs.url     = "github:NixOs/nixpkgs";  # unstable branch
  inputs.nixpkgs.url      = "github:NixOs/nixpkgs/release-22.11";
  inputs.unfree.url       = "github:numtide/nixpkgs-unfree";
  inputs.home-manager.url = "github:nix-community/home-manager/master";
  inputs.cd.url           = "github:cachix/cachix-deploy-flake";
  # inputs.unfree.inputs.nixpkgs.follows       = "nixpkgs";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs:
  let
    system = "x86_64-linux";
    pkgs = import "${inputs.nixpkgs}" {
      inherit system;
      config.allowUnfree = true;
    };
    mkOS   = module: inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules     = [ module ];
      specialArgs = { inherit inputs; };
    };
    cd-lib = inputs.cd.lib pkgs;
    cd     = cd-lib.spec {
      agents.T1 = cd-lib.nixos inputs.self.nixosModules.T1;
      agents.HP = cd-lib.nixos inputs.self.nixosModules.HP;
      agents.BO = cd-lib.nixos inputs.self.nixosModules.BO;
    };
  in {
    nixosConfigurations.BO   = mkOS inputs.self.nixosModules.BO;
    nixosConfigurations.HP   = mkOS inputs.self.nixosModules.HP;
    nixosConfigurations.T1   = mkOS inputs.self.nixosModules.T1;
    nixosModules.BO.imports  = [ inputs.self.nixosModules.cfg ./bo ];
    nixosModules.HP.imports  = [ inputs.self.nixosModules.cfg ./hp ];
    nixosModules.T1.imports  = [ inputs.self.nixosModules.cfg ./t1 ];
    nixosModules.cfg.imports = [ inputs.home-manager.nixosModules.home-manager ./cfg.nix ./hugosenari ./networking.nix ];
    packages.${system}.cd    = cd;
  };
}
