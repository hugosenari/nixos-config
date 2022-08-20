{ config, pkgs, lib, ... }:
{
  networking.enableIPv6 = false;
  networking.hosts."0.0.0.0"     = [ "postgres" "coltrane-api" ];
  networking.hosts."69.74.69.80" = [ "dev.live.cdn.optimum.net" ];

  # Set your time zone.
  time.timeZone      = "America/Sao_Paulo";

  # Select internationalisation properties.
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
  # Enable acpid
  services.acpid.enable         = true;
  # Enable CUPS to print documents.
  services.printing.enable      = false;
  # Configure keymap in X11
  services.xserver.enable       = true;
  services.xserver.layout       = "br";
  services.xserver.videoDrivers = ["fbdev" "modesetting"];
  services.xserver.xkbOptions   = "caps:swapescape";
  services.xserver.xkbVariant   = "nodeadkeys";
  # Enable the Enlightenment Desktop Environment.
  services.xserver.desktopManager.enlightenment.enable = true;
  services.xserver.displayManager.lightdm.enable       = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable      = true;
  services.pipewire.enable   = true;
  services.pipewire.alsa.enable       = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable      = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hugosenari.description  = "hugosenari";
  users.users.hugosenari.extraGroups  = [ "networkmanager" "wheel" "sudo" "lp" "docker" ];
  users.users.hugosenari.isNormalUser = true;
  users.users.hugosenari.shell        = pkgs.fish;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    busybox
    firefox
    git
    meld
    neovim
    ripgrep
    yj
  ];

  programs.command-not-found.enable  = false;
  programs.direnv.enable             = true;
  programs.fish.enable               = true;
  programs.fzf.enable                = true;
  programs.fzf.enableFishIntegration = true;
  programs.home-manager.enable       = true;
  programs.htop.enable               = true;
  programs.jq.enable                 = true;
  programs.mpv.enable                = true;
  programs.mtr.enable                = true;
  programs.neovim.defaultEditor      = true;
  programs.password-store.enable     = true;
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
