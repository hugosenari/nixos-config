let
  hp = {
    system   = "x86_64-linux";
    sshUser  = "nix-ssh";
    sshKey   = "/ect/hugosenari/.ssh/id_ecdsa-cert.pub";
    protocol = "ssh-ng";
    maxJobs  = 100;
    hostName = "hp.ka.gy";
    publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUVBLzhNZDM1OC9lWG1ZUW9ZeUhScjlMa3lCdjFSZ1FTYkgyWXVmMFl0bHEgcm9vdEBIUAo=";
  };
in
{
  # nix.distributedBuilds = true;
  # nix.buildMachines     = [hp];
  # nix.settings.substituters = [ "ssh-ng://nix-ssh@hp.ka.gy?trusted=true&want-mass-query=true" ];
}
