{lib, pkgs, config, ...}:
let cfg = config.networking;
in
{
  services.nscd.enable  = false;
  system.nssModules     = lib.mkForce [];
  networking.enableIPv6 = false;
  networking.firewall.enable       = false;
  networking.hosts."192.168.0.163" = [ "hp.lilasp" ];
  networking.hosts."192.168.0.167" = [ "t1.lilasp" ];
  networking.hosts."192.168.0.72"  = [ "bo.lilasp" ];
  networking.hosts."192.168.0.73"  = [ "mi.lilasp" ];
  environment.etc."hosts.d/1_system".source = pkgs.concatText "hosts" cfg.hostFiles;
  system.activationScripts.shosts.text =
    ''
      rm  /etc/hosts
      cat /etc/hosts.d/* 2>/dev/null >/etc/hosts || true
    '';
  networking.search = ["localhost" "lilasp"];
  networking.nameservers = [
    "1.1.1.1"
    "9.9.9.9"
    "8.8.8.8"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
    "2804:14d:1:0:181:213:132:2"
    "2804:14d:1:0:181:213:132:3"
  ];
}
