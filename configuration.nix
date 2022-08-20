{ config, pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.grub.device      = "/dev/sda";
  boot.loader.grub.enable      = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.timeout = 1;

  services.connman.enable    = true;
  services.connman.enableVPN = true;
  networking.hostName   = "HP";
  networking.enableIPv6 = false;
  # networking.networkmanager.enable = true;
  networking.hosts."0.0.0.0" = [
    "postgres"
    "coltrane-api"
  ];
  networking.hosts."69.74.69.80" = [
    "dev.live.cdn.optimum.net"
  ];

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

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

  # Enable the X11 windowing system.
  services.xserver.enable       = true;
  services.xserver.videoDrivers = ["fbdev" "modesetting"];

  # Enable the Enlightenment Desktop Environment.
  services.xserver.desktopManager.enlightenment.enable = true;
  # services.xserver.desktopManager.gnome.enable         = true;
  services.xserver.displayManager.lightdm.enable       = true;

  # Enable acpid
  services.acpid.enable = true;

  # Configure keymap in X11
  services.xserver.layout     = "br";
  services.xserver.xkbVariant = "nodeadkeys";
  services.xserver.xkbOptions = "caps:swapescape";

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable      = true;
  services.pipewire.enable   = true;
  services.pipewire.alsa.enable       = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable      = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hugosenari.description  = "hugosenari";
  users.users.hugosenari.extraGroups  = ["networkmanager" "wheel" "sudo" "lp" "docker"];
  users.users.hugosenari.isNormalUser = true;
  users.users.hugosenari.shell        = pkgs.fish;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    firefox
    meld
    neovim
    enlightenment.efl
    python39Packages.pythonefl
  ];
  # started in user sessions.
  programs.fish.enable                  = true;
  programs.mtr.enable                   = true;
  programs.neovim.defaultEditor         = true;
  programs.gnupg.agent.enable           = true;
  programs.gnupg.agent.enableSSHSupport = true;

  system.stateVersion = "22.05";
  nix.extraOptions    = "experimental-features = nix-command flakes";
  nix.package         = pkgs.nixFlakes;

  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-10.24.1"
    "nodejs-12.22.12"
    "nodejs-16.15.0"
  ];
  programs.ssh.extraConfig = ''
    Host *
      SendEnv LANG LC_*
      HashKnownHosts yes
      GSSAPIAuthentication yes
  '';

  virtualisation.docker.enable = true;
}
