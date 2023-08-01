{pkgs, config, inputs, lib, ...}:
let
  # NixOS 23.05 uses s5cmd 2.0 that doesn't have --credentials param
  s5cmd  = inputs.unstable.legacyPackages.${pkgs.system}.s5cmd;
  nushell= inputs.unstable.legacyPackages.${pkgs.system}.nushell;
  cfg    = config.services.my-own-cache-with-blackjack-and-hooks;
  filter = builtins.concatStringsSep "|" cfg.gc-filter;
  keep   = builtins.concatStringsSep "|" cfg.gc-keep;
  deref  = ''
    exec \
    ${pkgs.nushell}/bin/nu ${./dereference.nu} \
      --bucket    "${cfg.s3-bucket}"           \
      --creds     "${cfg.s3-cred}"             \
      --endpoint  "https://${cfg.s3-end}"      \
      --profile   "${cfg.s3-profile}"          \
      --keep      "'(${keep})'"                \
      --gcpath    "${cfg.gc-path}"
  '';
  gc     = ''
    exec \
    ${pkgs.nushell}/bin/nu ${./gc.nu}          \
      --bucket    "${cfg.s3-bucket}"           \
      --creds     "${cfg.s3-cred}"             \
      --endpoint  "https://${cfg.s3-end}"      \
      --profile   "${cfg.s3-profile}"          \
      --cachepath "${cfg.gc-cache}"
  '';
  gc-push = ''
    exec \
    ${pkgs.nushell}/bin/nu ${./gc-push.nu}  \
      --bucket    "${cfg.s3-bucket}"           \
      --creds     "${cfg.s3-cred}"             \
      --endpoint  "https://${cfg.s3-end}"      \
      --profile   "${cfg.s3-profile}"          \
      --filter    "'(${filter})'"              \
      --gcpath    "${cfg.gc-path}"
  '';
  s3-uri = "s3://${cfg.s3-bucket}?compression=zstd&profile=${cfg.s3-profile}&endpoint=${cfg.s3-end}";
  Q.path   = "/run/myOwnPkgCacheUploader";                                                          # FiFo
  Q.push   = pkgs.writeShellScript "myOwnCacheWithGCAndHooks" "echo $OUT_PATHS > ${Q.path}"; # Queue Writer
  Q.pop    = ''                                                                                     # Queue Reader
    test -e ${Q.path} || mkfifo  ${Q.path}
    tail -f ${Q.path}  | while read -r OUT_PATH; do
      ${Q.upload} $OUT_PATH &
    done
  '';
  Q.upload = pkgs.writeShellScript "myOwnPkgCacheUploader" ''                                       # Cache uploader
    echo Caching $1
    nix store sign --key-file '${cfg.sig-prv}' "$1"
    nix copy       --to       '${s3-uri}'      "$1"
  '';
in
{
  options.services.my-own-cache-with-blackjack-and-hooks = {
    enable    = lib.options.mkEnableOption "My Own Cache with blackjack and hooks";
    gc-cache  = lib.mkOption {
      description = "Absolute path to use as local cache for GC as string.";
      default     = "/tmp/nixgc.cache";
      type        = lib.types.str;
    };
    gc-path   = lib.mkOption {
      default     = "/nix/var/nix/gcroots";
      description = "Absolute path to use as local nix gcroot as string.";
      type        = lib.types.str;
    };
    gc-filter = lib.mkOption {
      default     = ["nixos-rebuild"];
      description = "Do not upload roots info for pkg matching";
      type        = lib.types.listOf lib.types.str;
    };
    gc-keep   = lib.mkOption {
      default     = ["Fluggaenkoecchicebolsen"];
      description = "Prevents roots info for pkg matching from going to trash";
      type        = lib.types.listOf lib.types.str;
    };
    s3-bucket = lib.mkOption {
      default     = "nixstore";
      description = "S3 Bucket";
      type        = lib.types.str;
    };
    s3-cred   = lib.mkOption {
      default     = "/etc/aws/credentials";
      description = "S3 Credentials absolute path as string";
      type        = lib.types.str;
    };
    s3-end     = lib.mkOption {
      description = "S3 Provider URL";
      type        = lib.types.str;
    };
    s3-profile = lib.mkOption {
      default     = "nixstore";
      description = "S3 Credentials profile";
      type        = lib.types.str;
    };
    sig-prv    = lib.mkOption {
      default     = "/etc/nix/nixstore-key";
      description = "Your pkgs signature private key absolute path as string";
      type        = lib.types.str;
    };
    sig-pub    = lib.mkOption { 
      description = "Your pkgs signarure public  key as string";
      type        = lib.types.str;
    };
  };

  config.nix.settings.substituters        = lib.mkIf cfg.enable [ s3-uri      ];
  config.nix.settings.trusted-public-keys = lib.mkIf cfg.enable [ cfg.sig-pub ];
  config.nix.settings.post-build-hook     = lib.mkIf cfg.enable Q.push;

  config.systemd.services = lib.mkIf cfg.enable { 
    nix-daemon.environment.AWS_SHARED_CREDENTIALS_FILE = cfg.s3-cred;
    pkgs-own-cache-dereference.description = "Mark gcroots as unused";
    pkgs-own-cache-dereference.enable      = true;
    pkgs-own-cache-dereference.path        = [ pkgs.gzip s5cmd ];
    pkgs-own-cache-dereference.script      = deref;
    pkgs-own-cache-dereference.wantedBy    = [ "multi-user.target" ];
    
    pkgs-own-cache-gc.description          = "Remove unused nar, narinfo, gcinfo files";
    pkgs-own-cache-gc.enable               = true;
    pkgs-own-cache-gc.path                 = [ pkgs.gzip s5cmd pkgs.gawk ];
    pkgs-own-cache-gc.script               = gc;
    pkgs-own-cache-gc.wantedBy             = [ "multi-user.target" ];
    
    pkgs-own-cache-gc-push.description     = "Send gcroots to private cache";
    pkgs-own-cache-gc-push.enable          = true;
    pkgs-own-cache-gc-push.path            = [ config.nix.package pkgs.gawk pkgs.gzip s5cmd ];
    pkgs-own-cache-gc-push.script          = gc-push;
    pkgs-own-cache-gc-push.wantedBy        = [ "multi-user.target" ];

    pkgs-own-cache-uploader.description    = "Send pkgs to private cache";
    pkgs-own-cache-uploader.enable         = true;
    pkgs-own-cache-uploader.path           = [ config.nix.package ];
    pkgs-own-cache-uploader.script         = Q.pop;
    pkgs-own-cache-uploader.wantedBy       = [ "multi-user.target" ];
    pkgs-own-cache-uploader.environment.CACHE_Q_PATH                = Q.path;
    pkgs-own-cache-uploader.environment.AWS_SHARED_CREDENTIALS_FILE = cfg.s3-cred;
  };
}
