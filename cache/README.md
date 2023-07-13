
## Why?

I need to setup my own nix cache because the alternatives while too good but too expensive for my needs.

## Features

- Uses any AWS S3 API compatible
- No additional server is required
- Garbage Collector based on GCRoot instead of size/age

## How it works

_Uploader_
- Watch nix gcroot dir for new entries
- Copy the new entry to tmpdir
- Collect gcinfo from this entry
- Send pkgs (nar), pkg meta (narinfo) to server like `nix copy` does
- Send gcinfo to server in gcroots/{HOSTNAME}/{pname}-{hash}.gcinfo.gz

_Dereference_
- Every 30min, list server gcinfo
- If they aren't in local gcroot move then to remote in gctrash/

_Garbage Collect_
- Download all gcinfo of gctrash/
- If wasn't empty, also download gcinfo from gcroots
- Filter gcinfo-trash from gcinfo-roots
- Delete

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

- Battle test it
- Move to other project
- Option to disable dereference, and TUI to choose what move to trash
- Option to collect garbage that doesn't have gcinfo


# Hints

- Use `--profile` (and `nix profile`) to have batter names version and control
