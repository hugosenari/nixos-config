{lib, config, ...}:
let 
  cfg = config.networking;
  dns = [
    "1.1.1.1"
    "8.8.8.8"
    "9.9.9.9"
    "2606:4700:4700::1001"
    "2606:4700:4700::1111"
    "2804:14d:1:0:181:213:132:2"
    "2804:14d:1:0:181:213:132:3"
  ];
in
{
  services.nscd.enable   = false;
  system.nssModules      = lib.mkForce [];
  networking.enableIPv6  = false;
  networking.search      = ["localhost" "ka.gy"];
  networking.nameservers = dns;
  networking.firewall.enable = false;
  networking.wireless.enable = true;
}
