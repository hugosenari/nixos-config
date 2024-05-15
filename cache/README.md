![image](https://github.com/hugosenari/nixos-config/assets/863299/1a1d4cb3-3384-457b-bd86-248657e5cd8f)

## Why?

There are good nix cache services (like [Cachix](https://www.cachix.org/)) or systems (like [Attic](https://docs.attic.rs/)) available, but I can't afford them.
And to use free tier of whatever provider I found, I must keep one eye on the storage size, collecting garbage frequently.
Since I don't think LRU is good enough, I'll try to mimic Nix Garbage Collector.

## Features

- Uses any AWS S3 API compatible
- Uses installed instances as Remote Garbage Collector
- Garbage Collector based on GCRoot instead of size/age

## How it works

_Nix Postbuild Hook_
- Nix post build hook send to FIFO pkg path
- One service that listen that FIFO
- Push to S3 in background to prevent blocking build

_GC(Info) Push_
- Watch nix gcroot dir for new GC roots (like NixOS Generation)
- Collect all dependencies narinfo paths in a file `{pname}-{hash}.gcinfo.gz`
- Send gcinfo to `s3:/{bucket}/gcroots/{hostname}/`

_Dereference_
- Every 30min, list server `s3:/{bucke}/gcroots/{HOSTNAME}/*.gcinfo.gz`
- If they aren't in local gcroot move them to `s3:/{bucket}/gctrash/`

_Collect Garbage_
- Every 1 hour, download all gcinfo of `s3:/{bucket}/gctrash/`
- If is't empty, also download all cfinfo of `s3:/{bucket}/gcroots/*/*.gcinfo.gz`
- For what left of gcinfo(trash) - gcinfo(gcroots) from server
- Get all NAR file urls
- Delete NAR and NARINFO
- Delete gcinfo.gz from gctrash

## Requirements

- Local NixOS
- AWS S3 or S3 API server

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

- Blackjack
- Battle test it,
- Add an option to configure gc-residual time,
- Option to disable dereference, and
- Commands to manually move to trash.

# Notes

- Use `--profile` (and `nix profile`) to have better names and control your GCROOT
- AWS and other providers, charge also by traffic/operation.
- We are ignoring `nixos-rebuild` because after that we have `nixos-system`
- Use gc-residual.nu to remove residual files
