{lib, pkgs, config, ...}:
let cfg = config.networking;
in
{
  services.nscd.enable  = false;
  system.nssModules = lib.mkForce [];
  networking.enableIPv6 = false;
  networking.firewall.enable       = false;
  networking.hosts."192.168.0.163" = [ "hp.lilasp" ];
  networking.hosts."192.168.0.167" = [ "t1.lilasp" ];
  networking.hosts."192.168.0.72"  = [ "bo.lilasp" ];
  networking.hosts."192.168.0.73"  = [ "mi.lilasp" ];
  environment.etc.hosts.source = lib.mkDefault null;
  environment.etc."hosts.d/system".source = pkgs.concatText "hosts" cfg.hostFiles;
  system.activationScripts.hosts.text =
    ''
      cat /etc/hosts.d/* 2>/dev/null >/etc/hosts || true
    '';
}
