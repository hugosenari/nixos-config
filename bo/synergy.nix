{
  services.synergy.server.address    = "bo.ka.gy";
  services.synergy.server.autoStart  = true;
  services.synergy.server.enable     = true;
  services.synergy.server.screenName = "bo";
  services.synergy.server.configFile = builtins.toFile "synergyCfg" ''
    section: screens
      t1:
      bo:
    end
    section: aliases
        t1:
          t1.ka.gy
        bo:
          bo.ka.gy
    end
    section: links
       t1:
           right = bo
           left  = bo
       bo:
           left  = t1
           right = t1
    end
  '';
}


