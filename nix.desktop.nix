{
  nix.distributedBuilds     = true;
  nix.buildMachines         = [{
    system   = "x86_64-linux";
    sshUser  = "hugosenari";
    sshKey   = "/home/hugosenari/.ssh/id_ecdsa-cert.pub";
    protocol = "ssh-ng";
    maxJobs  = 100;
    hostName = "hp.ka.gy";
    publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUVBLzhNZDM1OC9lWG1ZUW9ZeUhScjlMa3lCdjFSZ1FTYkgyWXVmMFl0bHEgcm9vdEBIUAo=";
  }];
}
