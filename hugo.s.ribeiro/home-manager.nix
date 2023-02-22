{pkgs, ...}: {
  imports = [ ../hugo/home-manager.nix ];
  home.homeDirectory = "/home/hugo.s.ribeiro";
  home.username      = "hugo.s.ribeiro";
  home.packages      = with pkgs; [
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
  ];
  programs.firefox.enable                = true;
  targets.genericLinux.enable            = true;
  services.cachix-agent.enable           = true;
  services.cachix-agent.name             = "BO";
  systemd.user.startServices             = "sd-switch";

  xdg.desktopEntries.firefox.name        = "Firefox";
  xdg.desktopEntries.firefox.genericName = "Web Browser";
  xdg.desktopEntries.firefox.exec        = "firefox";
  xdg.desktopEntries.firefox.terminal    = false;
  xdg.desktopEntries.firefox.categories  = [ "Application" "Network" "WebBrowser" ];
  xdg.desktopEntries.firefox.mimeType    = [ "text/html" "text/xml" ];

  systemd.user.services.synergy-client.Unit.Description  = "Synergy client";
  systemd.user.services.synergy-client.Unit.After        = [ "graphical-session.target" ];
  systemd.user.services.synergy-client.Unit.WantedBy     = "pipewire.service";
  systemd.user.services.synergy-client.Service.ExecStart = "${pkgs.synergy}/bin/synergyc -f -n bo hp.lilasp";
  systemd.user.services.synergy-client.Service.Restart   = "on-failure";
  systemd.user.services.synergy-client.Service.KillMode  = "mixed";
}
