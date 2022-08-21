{ config, pkgs, lib, ... }:
{
  networking.enableIPv6 = false;
  networking.hosts."0.0.0.0"       = [ "postgres" "coltrane-api" ];
  networking.hosts."69.74.69.80"   = [ "dev.live.cdn.optimum.net" ];
  networking.hosts."192.168.0.163" = [ "hp.lilasp" ];
  networking.hosts."192.168.0.167" = [ "t1.lilasp" ];
  networking.hosts."192.168.0.72"  = [ "mi.lilasp" ];

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

  services.connman.enable       = true;
  services.connman.enableVPN    = true;
  services.acpid.enable         = true;
  services.printing.enable      = false;
  services.xserver.enable       = true;
  services.xserver.layout       = "br";
  services.xserver.useGlamor    = true;
  services.xserver.xkbOptions   = "caps:swapescape";
  services.xserver.xkbVariant   = "nodeadkeys";
  services.xserver.desktopManager.enlightenment.enable = true;
  services.xserver.displayManager.lightdm.enable       = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable      = true;
  services.pipewire.enable   = true;
  services.pipewire.alsa.enable       = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable      = true;

  users.users.hugosenari.description  = "hugosenari";
  users.users.hugosenari.extraGroups  = [ "networkmanager" "wheel" "sudo" "lp" "docker" ];
  users.users.hugosenari.isNormalUser = true;
  users.users.hugosenari.shell        = pkgs.fish;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
    firefox
    git
    jq
    meld
    mtr
    neovim
    ripgrep
    yj
    lshw
  ];

  programs.gnupg.agent.enable           = true;
  programs.gnupg.agent.enableSSHSupport = true;

  system.stateVersion = "22.05";
  nix.extraOptions    = "experimental-features = nix-command flakes";
  nix.package         = pkgs.nixFlakes;
  nixpkgs.config.permittedInsecurePackages = ["nodejs-10.24.1" "nodejs-12.22.12" "nodejs-16.15.0"];

  programs.ssh.extraConfig = ''
    Host *
      SendEnv LANG LC_*
      HashKnownHosts yes
      GSSAPIAuthentication yes
  '';

  virtualisation.docker.enable = true;
}
