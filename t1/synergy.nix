{
  services.synergy.server.address    = "t1.lilasp";
  services.synergy.server.autoStart  = true;
  services.synergy.server.enable     = true;
  services.synergy.server.screenName = "t1";
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
           down  = hp
           right = bo
       hp:
           up    = t1
       bo:
           left  = t1
    end
    section: options
       # Switch screens on keypress
       keystroke(control+super+up)    = switchInDirection(up)
       keystroke(control+super+down)  = switchInDirection(down)
       keystroke(control+super+left)  = switchInDirection(left)
       keystroke(control+super+right) = switchInDirection(right)
    end
  '';

  # t1.lilasp and hp.lilasp are configured in networking.nix in 'networking.hosts. ...'
}
