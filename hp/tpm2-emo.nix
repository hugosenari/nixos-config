{ config, lib, pkgs, ... }:
{
  systemd.services.tpm2-emo.description = "tpm2 emulator";
  systemd.services.tpm2-emo.enable   = true; 
  systemd.services.tpm2-emo.path     = [ pkgs.swtpm ]; 
  systemd.services.tpm2-emo.wantedBy = [ "tpm2-abrmd.service" ];
  systemd.services.tpm2-emo.serviceConfig.StateDirectory   = "swtpm";
  systemd.services.tpm2-emo.serviceConfig.RuntimeDirectory = "swtpm";
  systemd.services.tpm2-emo.script = ''
    exec swtpm socket \
      --tpmstate dir=$STATE_DIRECTORY \
      --ctrl type=unixio,path=$RUNTIME_DIRECTORY/swtpm-sock \
      --tpm2
  '';
  systemd.services."tpm2-abrmd".path = [ config.security.tpm2.abrmd.package  pkgs.swtpm ];
  systemd.services."tpm2-abrmd".serviceConfig.ExecStart = lib.mkForce "tpm2-abrmd --tcti=\"swtpm\"";
}
