{
  services.synergy.server.address    = "bo.lilasp";
  services.synergy.server.autoStart  = true;
  services.synergy.server.enable     = true;
  services.synergy.server.screenName = "bo";
  services.synergy.server.configFile = builtins.toFile "synergyCfg" ''
    section: screens
      t1:
      hp:
      bo:
    end
    section: aliases
        t1:
          t1.lilasp
        hp:
          hp.lilasp
        bo:
          bo.lilasp
    end
    section: links
       t1:
           left  = hp
           right = bo
       hp:
           left  = bo
           right = t1
       bo:
           right = hp
           left  = t1
    end
  '';

  # t1.lilasp and hp.lilasp are configured in networking.nix in 'networking.hosts. ...'
}


