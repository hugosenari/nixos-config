{pkgs, ...}: {
  imports = [ ../hugo/home-manager.nix ];
  home.homeDirectory = "/home/hugo.s.ribeiro";
  home.username      = "hugo.s.ribeiro";
  home.packages      = with pkgs; [
    firefox
    git
    meld
    mtr
    remmina
    ripgrep
    unzip
    xdotool
    xarchiver
    yj
    zip
  ]

  services.cachix-agent.enable         = true;
  services.cachix-agent.name           = "BO";
  systemd.user.services.synergy-client = {
    Unit.Description  = "Synergy client";
    Unit.After        = [ "graphical-session.target" ];
    Service.ExecStart = "${pkgs.synergy}/bin/synergyc -f -n bo t1.lilasp";
    Service.Restart   = "on-failure";
    Service.KillMode  = "mixed";
  };
}
