{ pkgs, ... }:
{
  nix.gc.automatic                 = true;
  nix.gc.randomizedDelaySec        = "45min";
  nix.settings.auto-optimise-store = true;
  nix.settings.substituters        = [
    "s3://nixstore?compression=zstd&profile=nixstore&endpoint=q4n8.or.idrivee2-24.com" # My Cache
    "https://cache.ngi0.nixos.org/"                                                    # Content Addressed
  ];
  nix.settings.trusted-public-keys = [ 
    "nixstore:XPnWsxFA3W5WV9nl6TFA1EhYkehVMIZOs20wuAf8A5c="                            # My Cache
    "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="              # Content Addressed
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