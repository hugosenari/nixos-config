{
  networking.enableIPv6 = false;
  networking.firewall.enable       = false;
  networking.hosts."0.0.0.0"       = [ "postgres" "coltrane-api" ];
  networking.hosts."69.74.69.80"   = [ "dev.live.cdn.optimum.net" ];
  networking.hosts."192.168.0.163" = [ "hp.lilasp" ];
  networking.hosts."192.168.0.167" = [ "t1.lilasp" ];
  networking.hosts."192.168.0.72"  = [ "mi.lilasp" ];
}
