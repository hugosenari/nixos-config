# Function arguments
{
   config,  # object with all values configured, see also [options](https://search.nixos.org/options)
   pkgs,    # object with all installable packages, see also [packages](https://search.nixos.org/packages)
   lib,     # object with all stdlib functions, see also [builtins](https://nix.dev/manual/nix/stable/language/builtins.html)
   nixpkgs, # I defined in ./flake.nix, to have git referece of pkgs src
   ... 
}:
# Function returned object 
#   nix language doesn't have funcition body,
#   only one value can be returned,
#   nixos expects one object, with sub-attibutes
#   see also [options](https://search.nixos.org/options)
{
  # Programs are applications configured by nixos
  #   they are not only available in path,
  #   but also configured to work with other applications
  #   or as default app
  # Services are applications that run managed by systemd
  users.defaultUserShell       = pkgs.fish; # https://letmegooglethat.com/?q=monty+python+find+the+fish
  programs.fish.enable         = true;      # better shell ux
  programs.git.enable          = true;      # https://git-scm.com/
  programs.htop.enable         = true;      # better top ux
  programs.neovim.enable       = true;      # newer vim implementation
  programs.neovim.defaultEditor= true;
  programs.neovim.viAlias      = true;      # you say vi I say neovim
  programs.neovim.vimAlias     = true;      # you say vim I say neovim
  security.rtkit.enable        = true;      # process priority
  services.printing.enable     = false;     # prevents Amazon Deforestation
  services.logind.lidSwitchExternalPower = "ignore"; # do not suspend when lid close
  environment.systemPackages   = [          # other programs available in path
    pkgs.inetutils
    pkgs.lshw
    pkgs.lsof
    pkgs.tpm2-tools
    pkgs.unzip
    pkgs.zip
  ];

  # localization
  console.keyMap     = "br-abnt2";
  time.timeZone      = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_ADDRESS        = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_IDENTIFICATION = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_MEASUREMENT    = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_MONETARY       = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_NAME           = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_NUMERIC        = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_PAPER          = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_TELEPHONE      = "pt_BR.UTF-8";
  i18n.extraLocaleSettings.LC_TIME           = "pt_BR.UTF-8";
  services.interception-tools.plugins = [ pkgs.interception-tools-plugins.caps2esc ];
  services.interception-tools.enable  = true;
  home-manager.useUserPackages        = true;
}
