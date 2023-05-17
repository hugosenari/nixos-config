{
  description        = "Hugosenari Hosts";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";
  inputs.unfree.url  = "github:numtide/nixpkgs-unfree";
  inputs.hm.url      = "github:nix-community/home-manager/master";
  inputs.hm.inputs.nixpkgs.follows = "nixpkgs";

  nixConfig.extra-substituters        = [ 
    "s3://nixstore?profile=nixstore&endpoint=q4n8.or.idrivee2-24.com"
    "https://numtide.cachix.org"
  ];
  nixConfig.extra-trusted-public-keys = [
    "nixstore:XPnWsxFA3W5WV9nl6TFA1EhYkehVMIZOs20wuAf8A5c="
    "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
  ];

  outputs = {self, hm, ...}@inputs:
  let
    mkOS = module: inputs.nixpkgs.lib.nixosSystem {
      modules     = [ module ];
      system      = "x86_64-linux";
      specialArgs.inputs = inputs;
      specialArgs.unfree = inputs.unfree.x86_64-linux;
    };
  in {
    nixosConfigurations.BO   = mkOS self.nixosModules.BO;
    nixosConfigurations.HP   = mkOS self.nixosModules.HP;
    nixosConfigurations.T1   = mkOS self.nixosModules.T1;
    nixosModules.ALL.imports = [ hm.nixosModules.home-manager ./cfg.nix ./hugosenari ./networking.nix ];
    nixosModules.BO.imports  = [ self.nixosModules.ALL ./bo ];
    nixosModules.HP.imports  = [ self.nixosModules.ALL ./hp ];
    nixosModules.T1.imports  = [ self.nixosModules.ALL ./t1 ];
  };
}
