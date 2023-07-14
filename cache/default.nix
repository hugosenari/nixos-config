{pkgs, config, inputs, lib, ...}:
let
  # NixOS 23.05 uses s5cmd 2.0 that doesn't have --credentials param
  s5cmd  = inputs.unstable.legacyPackages.${pkgs.system}.s5cmd;
  nushell= inputs.unstable.legacyPackages.${pkgs.system}.nushell;
  cfg    = config.services.my-own-cache-with-blackjack-and-hooks;
  filter = builtins.concatStringsSep "|" cfg.gc-filter;
  deref  = ''
    ${pkgs.nushell}/bin/nu ${./dereference.nu} \
      --bucket    "${cfg.s3-bucket}"           \
      --creds     "${cfg.s3-cred}"             \
      --endpoint  "https://${cfg.s3-end}"     \
      --profile   "${cfg.s3-profile}"          \
      --gcpath    "${cfg.gc-path}"
  '';
  gc     = ''
    ${pkgs.nushell}/bin/nu ${./gc.nu}          \
      --bucket    "${cfg.s3-bucket}"           \
      --creds     "${cfg.s3-cred}"             \
      --endpoint  "https://${cfg.s3-end}"      \
      --profile   "${cfg.s3-profile}"          \
      --cachepath "${cfg.gc-cache}"
  '';
  upload = ''
    ${pkgs.nushell}/bin/nu ${./cache-push.nu}  \
      --bucket    "${cfg.s3-bucket}"           \
      --creds     "${cfg.s3-cred}"             \
      --endpoint  "https://${cfg.s3-end}"      \
      --profile   "${cfg.s3-profile}"          \
      --sig       "${cfg.sig-prv}"             \
      --filter    "(${filter})"                \
      --gcpath    "${cfg.gc-path}"
  '';
  s3_uri = "s3://${cfg.s3-bucket}?compression=zstd&profile=${cfg.s3-profile}&endpoint=${cfg.s3-end}";
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
      description = "Ignore root packages matching";
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

  config.nix.settings.substituters        = lib.mkIf cfg.enable [ s3_uri      ];
  config.nix.settings.trusted-public-keys = lib.mkIf cfg.enable [ cfg.sig-pub ];

  config.systemd.services = lib.mkIf cfg.enable { 
    nix-daemon.environment.AWS_SHARED_CREDENTIALS_FILE = cfg.s3-cred;
    pkgs-own-cache-dereference.description = "Remove unused gcinfo files";
    pkgs-own-cache-dereference.enable      = true;
    pkgs-own-cache-dereference.path        = [ pkgs.gzip s5cmd ];
    pkgs-own-cache-dereference.script      = deref;
    pkgs-own-cache-dereference.wantedBy    = [ "multi-user.target" ];
    
    pkgs-own-cache-gc.description          = "Remove unused nar files";
    pkgs-own-cache-gc.enable               = true;
    pkgs-own-cache-gc.path                 = [ pkgs.gzip s5cmd ];
    pkgs-own-cache-gc.script               = gc;
    pkgs-own-cache-gc.wantedBy             = [ "multi-user.target" ];
    
    pkgs-own-cache-push.description        = "Send gcroots to private cache";
    pkgs-own-cache-push.enable             = true;
    pkgs-own-cache-push.path               = [ config.nix.package pkgs.gzip s5cmd ];
    pkgs-own-cache-push.script             = upload;
    pkgs-own-cache-push.wantedBy           = [ "multi-user.target" ];
    pkgs-own-cache-push.environment.AWS_SHARED_CREDENTIALS_FILE = cfg.s3-cred;
  };
}
