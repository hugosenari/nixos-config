{lib, ...}:
let 
  dns = [
    "1.1.1.1"
    "8.8.8.8"
    "9.9.9.9"
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
