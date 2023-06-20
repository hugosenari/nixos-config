inputs: system: {
  os   = module: inputs.nixpkgs.lib.nixosSystem {
    modules = [ inputs.hm.nixosModules.home-manager module ];
    system  = system;
    specialArgs.inputs = inputs;
    specialArgs.unfree = inputs.unfree.${system};
  };
  home = module: inputs.hm.lib.homeManagerConfiguration {
    modules = [ module ];
    pkgs    = inputs.nixpkgs.legacyPackages.${system};
    extraSpecialArgs.inputs = inputs;
    extraSpecialArgs.unfree = inputs.unfree.${system};
  };
}
