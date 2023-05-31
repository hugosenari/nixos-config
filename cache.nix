{ pkgs, config, ... }:
let
  s3.cred  = "/etc/aws/credentials";                                                                # S3 Credentials
  s3.uri   = "s3://nixstore?compression=zstd&profile=nixstore&endpoint=q4n8.or.idrivee2-24.com";    # Private S3 URI
  sig.prv  = "/etc/nix/nixstore-key";                                                               # Sign Private Key
  sig.pub  = "nixstore:XPnWsxFA3W5WV9nl6TFA1EhYkehVMIZOs20wuAf8A5c=";                               # Sign Public  Key
  Q.path   = "/run/myOwnPkgCacheUploader";                                                          # Queue
  Q.push   = pkgs.writeShellScript "myOwnCacheWithBlackjackAndHooks" "echo $OUT_PATHS > ${Q.path}"; # Queue Writer
  Q.pop    = ''                                                                                     # Queue Reader
    test -e ${Q.path} || mkfifo  ${Q.path}
    tail -f ${Q.path}  | while read -r OUT_PATH; do
      ${Q.upload} $OUT_PATH &
    done
  '';
  Q.upload = pkgs.writeShellScript "myOwnPkgCacheUploader" ''                                       # Cache uploader
    echo Caching $1
    nix store sign --key-file '${sig.prv}' "$1"
    nix copy       --to       '${s3.uri}'  "$1"
  '';
in
{
  nix.gc.automatic                 = true;
  nix.gc.randomizedDelaySec        = "45min";
  nix.settings.auto-optimise-store = true;
  nix.settings.substituters        = [ s3.uri  ];
  nix.settings.trusted-public-keys = [ sig.pub ];
  nix.settings.post-build-hook     = Q.push;
  systemd.services.pkgs-cache-uploader.description = "Send pkgs to private cache";
  systemd.services.pkgs-cache-uploader.enable      = true;
  systemd.services.pkgs-cache-uploader.path        = [ config.nix.package ];
  systemd.services.pkgs-cache-uploader.script      = Q.pop;
  systemd.services.pkgs-cache-uploader.wantedBy    = [ "multi-user.target" ];
  systemd.services.pkgs-cache-uploader.environment.CACHE_Q_PATH                = Q.path;
  systemd.services.pkgs-cache-uploader.environment.AWS_SHARED_CREDENTIALS_FILE = s3.cred;
  systemd.services.nix-daemon.environment.AWS_SHARED_CREDENTIALS_FILE          = s3.cred;
}
