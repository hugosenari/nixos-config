{
  description = "My own cache with blackjack and hooks";
  inputs.v2505.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.xdb.url   = "github:crossdb-org/crossdb/0.14.0";
  inputs.xdb.flake = false;
  outputs = inputs: {
    nixosModules.my-own-cache-with-blackjack-and-hooks.imports = [ ./default.nix ];
    packages.x86_64-linux.default = inputs.v2505.legacyPackages.x86_64-linux.callPackage ./crossdb.nix {
      version = "0.14.0";
      src = inputs.xdb;
    };
  };
}
