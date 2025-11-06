{ inputs, config, lib, ...}:
let
 pkgVer = builtins.replaceStrings ["."] ["_"] config.system.stateVersion;
in {
  # nix
  nix.gc.automatic                 = true;
  nix.gc.dates                     = "weekly";
  nix.gc.randomizedDelaySec        = "46min";
  nix.registry.nixpkgs.from.id     = "nixpkgs";
  nix.registry.nixpkgs.from.type   = "indirect";
  nix.registry.nixpkgs.to.owner    = "NixOS";
  nix.registry.nixpkgs.to.ref      = inputs."v${pkgVer}".sourceInfo.rev;
  nix.registry.nixpkgs.to.repo     = "nixpkgs";
  nix.registry.nixpkgs.to.type     = "github";
  nixpkgs.config.allowUnfree       = true;
  nix.settings.auto-optimise-store = true;
  nix.settings.trusted-users       = [ "root" "hugosenari" "@nixbld" ];
  nix.settings.trusted-public-keys = [ 
    "cache.ka.gy-1:eBtYnEQTdI34kRm3+Vo7+IwmumWGITyi67rYjUh91aY="
  ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes ca-derivations
    connect-timeout       = 1
    fallback              = true
    warn-dirty            = false
  '';

  nixpkgs.hostPlatform      = "x86_64-linux";
  system.autoUpgrade.enable = true;             # auto upgrade my nixos installation and configs
  system.autoUpgrade.dates  = "*-*-* *:20:00";  # try upgrade every 20min, nothing is done if no change
  system.autoUpgrade.flags  = ["--refresh"];    # no repo cache for upgrade
  system.autoUpgrade.flake  = "github:hugosenari/nixos-config#${config.networking.hostName}"; # source
  system.autoUpgrade.randomizedDelaySec = "5m"; # prevents all machine to upgrade at exactly same time
}
