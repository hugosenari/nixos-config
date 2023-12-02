{ config, pkgs, lib, inputs, ... }:
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
    ripgrep
    unzip
    xarchiver
    yj
    zip
    pam_usb
  ];

  programs.gnupg.agent.enable           = true;
  programs.gnupg.agent.enableSSHSupport = true;
  programs.ssh.extraConfig              = ''
    Host *
      AddKeysToAgent yes
      GSSAPIAuthentication yes
      HashKnownHosts yes
      SendEnv LANG LC_*
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

  nix.extraOptions = "experimental-features = nix-command flakes ca-derivations";
  nix.package      = pkgs.nixVersions.nix_2_15;
  nix.gc.automatic                 = true;
  nix.gc.randomizedDelaySec        = "46min";
  nix.gc.dates                     = "weekly";
  nix.settings.auto-optimise-store = true;
  nix.settings.substituters        = [ "https://numtide.cachix.org" ];
  nix.settings.trusted-public-keys = [ "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE=" ];
  nix.settings.trusted-users       = [ "root" "hugosenari" "@nixbld" ];
  nix.registry.nixpkgs.from.id     = "nixpkgs";
  nix.registry.nixpkgs.from.type   = "indirect";
  nix.registry.nixpkgs.to.owner    = "NixOS";
  nix.registry.nixpkgs.to.repo     = "nixpkgs";
  nix.registry.nixpkgs.to.type     = "github";
  nix.registry.nixpkgs.to.ref      = inputs.nixpkgs.sourceInfo.rev;

  nix.registry.unfree.from.id      = "unfree";
  nix.registry.unfree.from.type    = "indirect";
  nix.registry.unfree.to.owner     = "numtide";
  nix.registry.unfree.to.repo      = "nixpkgs-unfree";
  nix.registry.unfree.to.type      = "github";
  nix.registry.unfree.to.ref       = inputs.unfree.sourceInfo.rev;

  security.rtkit.enable        = true;
  services.acpid.enable        = true;
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
  services.xserver.displayManager.lightdm.greeters.gtk.enable = true;
  services.xserver.displayManager.lightdm.greeters.gtk.extraConfig = ''
    indicators =  ~host;~spacer;~clock;~spacer;~layout;~language;~session;~a11y;~power
    keyboard = ${pkgs.onboard}/bin/onboard
  '';

  sound.enable        = true;
  system.stateVersion = "23.11";

  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates  = "12:43";
  system.autoUpgrade.flake  = "github:hugosenari/nixos-config#${config.networking.hostName}";
  system.autoUpgrade.randomizedDelaySec = "5m";
 
  virtualisation.docker.enable = false;

  services.my-own-cache-with-blackjack-and-hooks.enable  = true;
  services.my-own-cache-with-blackjack-and-hooks.s3-end  = "q4n8.or.idrivee2-24.com";
  services.my-own-cache-with-blackjack-and-hooks.sig-pub = "nixstore:XPnWsxFA3W5WV9nl6TFA1EhYkehVMIZOs20wuAf8A5c=";
}
