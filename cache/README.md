![image](https://github.com/hugosenari/nixos-config/assets/863299/1a1d4cb3-3384-457b-bd86-248657e5cd8f)

## Why?

There are good nix cache services (like [Cachix](https://www.cachix.org/)) or systems (like [Attic](https://docs.attic.rs/)) available, but I can't afford them.
And to use free tier of whatever provider I found, I must keep one eye on the storage size, running collector garbage frequently.
Since I don't think LRU is good enough, I'll try to mimic Nix garbage collector.

## Features

- Uses any AWS S3 API compatible
- Uses installed instances as Remote Garbage Collector
- Garbage Collector based on GCRoot instead of size/age

## How it works

_Uploader_
- Watch nix gcroot dir for new packages
- Copy the package and dependencies to temporary local directory with `nix copy`
- Collect all dependencies nar and narinfo paths in a file gcroots/{HOSTNAME}/{pname}-{hash}.gcinfo.gz
- Send pkgs (nar), pkg meta (narinfo), garbage collection info (gcinfo) to server

_Dereference_
- Every 30min, list server gcroots/{HOSTNAME}/*.gcinfo.gz
- If they aren't in local gcroot move then to remote in gctrash/

_Collect Garbage_
- Every 1 hour, download all TrashGCInfo of gctrash/*.gcinfo.gz
- If is't empty, also download all RootsGCInfo of gcroots/*/*.gcinfo.gz
- Delete what is left of TrashGCInfo - RootsGCInfo

## Requirements

- NixOS
- AWS S3 or alternatives
- 2x of your closure size in disk (for tmp operations)


## Installation

```nix
{
  inputs.my-own-cache-with-blackjack-and-hooks.url = "github:hugosenari/nixos-config?dir=cache";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";

  outputs = inputs: {
    nixosConfiguration.HOSTNAME = inputs.nixpkgs.lib.nixosSystem {
      system  = "x86_64-linux";
      specialArgs.inputs = inputs;
      modules = [
        # ... your other configs here or after
        inputs.my-own-cache-with-blackjack-and-hooks.nixosModules.my-own-cache-with-blackjack-and-hooks
        {
          my-own-cache-with-blackjack-and-hooks.enable     = true;
          # Create the bucket/or update here if you already has one
          my-own-cache-with-blackjack-and-hooks.s3-bucket  = "nixstore";
          # Create this file for s3 client
          my-own-cache-with-blackjack-and-hooks.s3-cred    = "/etc/aws/credentials"; # note this is a string not a path for sec reasons
          # Update it with the profile in your credentials file
          my-own-cache-with-blackjack-and-hooks.s3-profile = "nixstore";
          # Update it with your current provider url  
          my-own-cache-with-blackjack-and-hooks.s3-end     = "q0n0.0r.idrivee2-24.com";

          # Create this file to sign your packages         https://nixos.wiki/wiki/Binary_Cache#1._Generating_a_private.2Fpublic_keypair
          my-own-cache-with-blackjack-and-hooks.sig-prv    = "/etc/nix/nixstore-key"; # note this is a string not a path for sec reasons
          # Update this with you public key generated for you sign key
          my-own-cache-with-blackjack-and-hooks.sig-pub    = "nixstore:XPnWsxF43W5WV9nl6TFA1EhYkehVMIZOs20wu4f8A5c="; 
        }
      ];
    };
  };
}
```

# TODO

- Battle test it,
- Option to collect garbage that doesn't have gcinfo
- Option to disable dereference, and
- Commands to manually move to trash.

# Notes

- Use `--profile` (and `nix profile`) to have better names and control your GCROOT
- AWS and other providers, charge also by traffic/operation.
- We are ignoring `nixos-rebuild` because after that we have `nixos-system`
