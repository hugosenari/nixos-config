{
  networking.enableIPv6 = false;
  networking.firewall.enable       = false;
  networking.hosts."192.168.0.163" = [ "hp.lilasp" ];
  networking.hosts."192.168.0.167" = [ "t1.lilasp" ];
  networking.hosts."192.168.0.72"  = [ "bo.lilasp" ];
  networking.hosts."192.168.0.73"  = [ "mi.lilasp" ];
}
