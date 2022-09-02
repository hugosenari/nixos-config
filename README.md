# NixOS Configuration

These are my [NixOS](https://nixos.org/) Linux configurations and my [.files](https://github.com/nix-community/home-manager#home-manager-using-nix) home configurations.

This files and folders are:

- `cfg.nix` common system configurations;
- `networking.nix` common networking configurations;
- `hp` HP Pavilion DM4 machine configurations;
- `t1` One Notebook T1 machine configurations;
- `hugosenari` user configuration;
- `flake.nix` nix [flakes](https://www.tweag.io/blog/2020-05-25-flakes/) of this repository.

## Adding a new user

Duplicate `hugosenari` directory and change for user needs.

Add it to `flake.nix`.

Run `sudo nixos-rebuild switch --flake`

## Installing / Adding a machine

Follow NixOS [installation instructions](https://nixos.org/manual/nixos/stable/index.html#sec-installation).

Clone this inside `/etc/nixos`.

Duplicate `hp` directory as machine name.

Move hardware.nix to the new directory.

Add the new directory to git.

Add the host ip to `networking.nix`.

Add it to `flake.nix`.

If required add it to `synergy.nix` config in `t1` directory.

Run `sudo nixos-rebuild switch --flake`
