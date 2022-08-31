# lets waste some resources
{ pkgs, ...}:
{
  environment.systemPackages = [ 
    pkgs.eclipses.eclipse-jee
    pkgs.vscode
    pkgs.android-studio
  ];
}
