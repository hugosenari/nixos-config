{
  nix.distributedBuilds = true;
  nix.buildMachines     = [{
    system   = "x86_64-linux";
    sshUser  = "nix-ssh";
    sshKey   = "/home/hugosenari/.ssh/id_ecdsa-cert.pub";
    protocol = "ssh-ng";
    maxJobs  = 100;
    hostName = "hp.ka.gy";
    publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUVBLzhNZDM1OC9lWG1ZUW9ZeUhScjlMa3lCdjFSZ1FTYkgyWXVmMFl0bHEgcm9vdEBIUAo=";
  }];
  nix.settings.substituters = [ "ssh-ng://nix-ssh@hp.ka.gy?trusted=true&want-mass-query=true" ];
}
