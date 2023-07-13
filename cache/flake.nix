{
  description = "My own cache with blackjack and hooks";
  outputs = { self }: {
    nixosModules.my-own-cache-with-blackjack-and-hooks.imports = [ ./default.nix ];
  };
}
