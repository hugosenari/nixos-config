{
  services.synergy.server.address    = "t1.lilasp";
  services.synergy.server.autoStart  = true;
  services.synergy.server.enable     = true;
  services.synergy.server.screenName = "t1";
  services.synergy.server.configFile = builtins.toFile "synergyCfg" ''
    section: screens
      t1:
      hp:
    end
    section: aliases
        t1:
          t1.lilasp
        hp:
          hp.lilasp
    end
    section: links
       t1:
           left = hp
       hp:
           right = t1
    end
  '';
}
