{ pkgs, ... }:
{
  nix.gc.automatic                 = true;
  nix.gc.randomizedDelaySec        = "45min";
  nix.settings.auto-optimise-store = true;
  nix.settings.substituters        = [
    "s3://nixstore?compression=zstd&profile=nixstore&endpoint=q4n8.or.idrivee2-24.com"
    "https://nix-community.cachix.org"
    "https://numtide.cachix.org"
  ];
  nix.settings.trusted-public-keys = [ 
    "nixstore:XPnWsxFA3W5WV9nl6TFA1EhYkehVMIZOs20wuAf8A5c="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
  ];
  nix.settings.post-build-hook     = pkgs.writeShellScript "myOwnCacheWithBlackjackAndHooks" ''
    nix store sign --key-file /etc/nix/nixstore-key $OUT_PATHS
    export AWS_SHARED_CREDENTIALS_FILE=/etc/aws/credentials
    exec nix copy \
      --to 's3://nixstore?compression=zstd&profile=nixstore&endpoint=q4n8.or.idrivee2-24.com' \
      $OUT_PATHS
  '';
  systemd.services.nix-daemon.serviceConfig.Environment = ''"AWS_SHARED_CREDENTIALS_FILE=/etc/aws/credentials"'';
}
