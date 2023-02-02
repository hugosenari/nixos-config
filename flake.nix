{
  description             = "Hugosenari Hosts";
  #inputs.nixpkgs.url     = "github:NixOs/nixpkgs";  # unstable branch
  inputs.nixpkgs.url      = "github:NixOs/nixpkgs/release-22.11";
  inputs.home-manager.url = "github:nix-community/home-manager/master";
  inputs.cd.url           = "github:cachix/cachix-deploy-flake";
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
    mkHM   = modules: inputs.home-manager.lib.homeManagerConfiguration {
      inherit modules pkgs;
    };
    cd-lib = inputs.cd.lib pkgs;
    cd     = cd-lib.spec {
      agents.T1 = cd-lib.nixos           inputs.self.nixosModules.T1;
      agents.HP = cd-lib.nixos           inputs.self.nixosModules.HP;
      agents.BO = cd-lib.homeManager { } inputs.self.homeModules.BO;
    };
  in {
    homeConfigurations."hugo.s.ribeiro@wpteng279"  = mkHM [ inputs.self.homeModules.BO ];
    homeModules.BO.imports   = [ ./hugo.s.ribeiro/home-manager.nix ];
    nixosConfigurations.HP   = mkOS inputs.self.nixosModules.HP;
    nixosConfigurations.T1   = mkOS inputs.self.nixosModules.T1;
    nixosModules.HP.imports  = [ inputs.self.nixosModules.cfg ./hp ];
    nixosModules.T1.imports  = [ inputs.self.nixosModules.cfg ./t1 ];
    nixosModules.cfg.imports = [ inputs.home-manager.nixosModules.home-manager ./cfg.nix ./hugosenari ./networking.nix ];
    packages.${system}.cd    = cd;
  };
}
