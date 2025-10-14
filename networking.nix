{lib, ...}:
{
  services.nscd.enable   = false;                  # no local dns
  system.nssModules      = lib.mkForce [];         # no nss modules please
  networking.enableIPv6  = false;                  # no IPv6
  networking.search      = ["localhost" "ka.gy"];  # we are ka.gy
  networking.nameservers = [
    "192.174.68.104"     # ns.inwx.com the ka.gy domain admin
    "1.1.1.1"            # cloudflare dns
    "8.8.8.8"            # google dns
    "9.9.9.9"            # quad9 dns
  ];
  networking.firewall.enable       = false;
  networking.networkmanager.enable = true;
  # client SSH config
  programs.ssh.extraConfig         = ''
    Host *
      AddKeysToAgent yes
      HashKnownHosts yes
      SendEnv LANG LC_*
    Host *.ka.gy
      IdentityAgent none
      PKCS11Provider /run/current-system/sw/lib/libtpm2_pkcs11.so
  '';
  # server SSH config
  services.openssh.enable      = true;      # login over network
  # TPM2 Authorities that I trust (all ka.gy machines)
  services.openssh.extraConfig = "\nTrustedUserCAKeys ${./ssh.ka.gy.pub}\n"; 
  security.tpm2.enable         = true;
  security.tpm2.abrmd.enable   = true;
  security.tpm2.pkcs11.enable  = true;
  security.tpm2.tctiEnvironment.enable    = true;
  security.tpm2.tctiEnvironment.interface = "tabrmd";
}
