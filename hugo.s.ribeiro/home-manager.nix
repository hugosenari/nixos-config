{pkgs, ...}: {
  imports = [ ../hugo/home-manager.nix ];
  home.homeDirectory = "/home/hugo.s.ribeiro";
  home.username      = "hugo.s.ribeiro";

  systemd.user.services.synergy-client = {
    Unit.Description  = "Synergy client";
    Unit.After        = [ "graphical-session.target" ];
    Service.ExecStart = "${pkgs.synergy}/bin/synergyc -f -n bo t1.lilasp";
    Service.Restart   = "on-failure";
    Service.KillMode  = "mixed";
  };
}
