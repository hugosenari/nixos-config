{ config, pkgs, lib, inputs, ... }:
{
  system.stateVersion = "25.05";
  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
    firefox
    git
    inetutils
    lshw
    lsof
    meld
    neovim
    pulseaudio
    enlightenment.terminology
    tpm2-tools
    unzip
    xarchiver
    zip
  ];

  programs.gnupg.agent.enable           = true;
  programs.gnupg.agent.enableSSHSupport = true;
  programs.ssh.extraConfig              = ''
    Host *
      AddKeysToAgent yes
      GSSAPIAuthentication yes
      HashKnownHosts yes
      SendEnv LANG LC_*
    Host *.ka.gy
      IdentityAgent none
      PKCS11Provider /run/current-system/sw/lib/libtpm2_pkcs11.so
  '';
  services.sshd.enable         = true;
  services.openssh.settings.X11Forwarding = true;
  services.openssh.extraConfig = ''
    TrustedUserCAKeys ${./ssh.ka.gy.pub}
  '';

  time.timeZone      = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_ADDRESS        = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_IDENTIFICATION = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_MEASUREMENT    = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_MONETARY       = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_NAME           = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_NUMERIC        = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_PAPER          = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_TELEPHONE      = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_TIME           = "pt_BR.UTF-8";

  services.pulseaudio.enable = false;

  nix.gc.automatic                 = true;
  nix.gc.randomizedDelaySec        = "46min";
  nix.gc.dates                     = "weekly";
  nix.settings.auto-optimise-store = true;
  nix.settings.substituters        = [ "https://numtide.cachix.org" ];
  nix.settings.trusted-public-keys = [ 
    "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    "t1.ka.gy-1:ZOlSF/x1GTe4G7yoLiWarIRGUhFcYWgVfWx68x1LUWQ="
    "bo.ka.gy-1:q4Rj6nHsu2gYkwUSJ7W/KzbXskVC1jvqt7b2RgUqp8o="
  ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes ca-derivations
    connect-timeout       = 1
    fallback              = true
    warn-dirty            = false
  '';
  nix.settings.trusted-users       = [ "root" "hugosenari" "@nixbld" ];
  nix.registry.nixpkgs.from.id     = "nixpkgs";
  nix.registry.nixpkgs.from.type   = "indirect";
  nix.registry.nixpkgs.to.owner    = "NixOS";
  nix.registry.nixpkgs.to.repo     = "nixpkgs";
  nix.registry.nixpkgs.to.type     = "github";
  nix.registry.nixpkgs.to.ref      = inputs.nixpkgs.sourceInfo.rev;

  security.rtkit.enable        = true;
  security.tpm2.enable         = true;
  security.tpm2.pkcs11.enable  = true;
  security.tpm2.abrmd.enable   = true;
  security.tpm2.tctiEnvironment.enable = true;
  security.tpm2.tctiEnvironment.interface = "tabrmd";
  services.acpid.enable        = true;
  services.pipewire.enable     = true;
  services.pipewire.alsa.enable       = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable      = true;

  services.printing.enable    = false;
  networking.networkmanager.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates  = "*-*-* *:20:00";
  system.autoUpgrade.flake  = "github:hugosenari/nixos-config#${config.networking.hostName}";
  system.autoUpgrade.flags  = ["--refresh"];
  system.autoUpgrade.randomizedDelaySec = "5m";

  services.xserver.enable     = true;
  services.xserver.xkb.layout     = "br";
  services.xserver.xkb.options = "caps:swapescape";
  services.xserver.xkb.variant = "nodeadkeys";
  services.xserver.displayManager.gdm.enable  = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.harmonia.enable = true;

  services.interception-tools.enable = true;
  services.interception-tools.plugins = [ pkgs.interception-tools-plugins.caps2esc ];
  services.interception-tools.udevmonConfig = lib.strings.toJSON [{
    DEVICE.EVENTS.EV_KEY = [ "KEY_CAPSLOCK" "KEY_ESC" ];
    JOB = builtins.concatStringsSep " | " [
      "${pkgs.interception-tools}/bin/intercept -g $DEVNODE"
      "${lib.getExe pkgs.interception-tools-plugins.caps2esc} -m 1 -t 0" 
      "${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
    ];
  }];
}   
