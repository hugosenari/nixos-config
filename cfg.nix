{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
    firefox
    git
    inetutils
    jq
    lshw
    lsof
    meld
    mtr
    neovim
    pulseaudio
    remmina
    ripgrep
    unzip
    xdotool
    xarchiver
    yj
    zip
    cachix
  ];


  programs.gnupg.agent.enable           = true;
  programs.gnupg.agent.enableSSHSupport = true;
  programs.ssh.extraConfig              = ''
    Host *
      SendEnv LANG LC_*
      HashKnownHosts yes
      GSSAPIAuthentication yes
  '';

  time.timeZone      = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.utf8";
  i18n.extraLocaleSettings.LC_ADDRESS        = "pt_BR.utf8";
  i18n.extraLocaleSettings.LC_IDENTIFICATION = "pt_BR.utf8";
  i18n.extraLocaleSettings.LC_MEASUREMENT    = "pt_BR.utf8";
  i18n.extraLocaleSettings.LC_MONETARY       = "pt_BR.utf8";
  i18n.extraLocaleSettings.LC_NAME           = "pt_BR.utf8";
  i18n.extraLocaleSettings.LC_NUMERIC        = "pt_BR.utf8";
  i18n.extraLocaleSettings.LC_PAPER          = "pt_BR.utf8";
  i18n.extraLocaleSettings.LC_TELEPHONE      = "pt_BR.utf8";
  i18n.extraLocaleSettings.LC_TIME           = "pt_BR.utf8";

  hardware.pulseaudio.enable = false;

  nix.extraOptions = "experimental-features = nix-command flakes";
  nix.package      = pkgs.nixFlakes;
  nix.gc.automatic = true;
  nix.gc.randomizedDelaySec = "45min";
  nix.settings.auto-optimise-store = true;
  nix.settings.substituters        = [
    "s3://nixstore?profile=nixstore&endpoint=q4n8.or.idrivee2-24.com"
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
    export AWS_CREDENTIAL_PROFILES_FILE=/etc/aws/credentials
    exec nix copy \
      --to 's3://nixstore?profile=nixstore&endpoint=q4n8.or.idrivee2-24.com' \
      $OUT_PATHS &
  '';
  systemd.services.nix-daemon.serviceConfig.Environment = ''"AWS_CREDENTIAL_PROFILES_FILE=/etc/aws/credentials"'';
  nix.settings.trusted-users       = [ "root" "hugosenari" ];

  security.rtkit.enable        = true;
  services.acpid.enable        = true;
  services.cachix-agent.enable = true;
  services.connman.enable      = true;
  services.connman.enableVPN   = true;
  services.pipewire.enable     = true;
  services.pipewire.alsa.enable       = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable      = true;

  services.printing.enable    = false;
  services.sshd.enable        = true;
  services.xserver.enable     = true;
  services.xserver.layout     = "br";
  services.xserver.xkbOptions = "caps:swapescape";
  services.xserver.xkbVariant = "nodeadkeys";
  services.xserver.desktopManager.enlightenment.enable = true;
  services.xserver.displayManager.lightdm.enable       = true;

  sound.enable        = true;
  system.stateVersion = "22.05";

  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates  = "2 h";
  system.autoUpgrade.flake  = "github:hugosenari/nixos-config#${config.networking.hostName}";
  system.autoUpgrade.randomizedDelaySec = "5m";
 
  virtualisation.docker.enable = true;
}
