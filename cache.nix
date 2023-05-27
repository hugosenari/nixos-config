{ pkgs, ... }:
{
  nix.gc.automatic                 = true;
  nix.gc.randomizedDelaySec        = "45min";
  nix.settings.auto-optimise-store = true;
  nix.settings.substituters        = [
    "s3://nixstore?compression=zstd&profile=nixstore&endpoint=q4n8.or.idrivee2-24.com" # My Cache Private S3
  ];
  nix.settings.trusted-public-keys = [ 
    "nixstore:XPnWsxFA3W5WV9nl6TFA1EhYkehVMIZOs20wuAf8A5c="                            # My Cache Public Key
  ];
  nix.settings.post-build-hook     = pkgs.writeShellScript "myOwnCacheWithBlackjackAndHooks" ''
    NIXSIGN_KEY=/etc/nix/nixstore-key                                                  # My Cache Private Key
    nix store sign --key-file $NIXSIGN_KEY $OUT_PATHS
    export AWS_SHARED_CREDENTIALS_FILE=/etc/aws/credentials
    nix copy \
      --to 's3://nixstore?compression=zstd&profile=nixstore&endpoint=q4n8.or.idrivee2-24.com' \
      $OUT_PATHS &
  '';
  systemd.services.nix-daemon.serviceConfig.Environment = ''"AWS_SHARED_CREDENTIALS_FILE=/etc/aws/credentials"'';
}
