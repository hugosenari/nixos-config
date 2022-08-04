{ config, pkgs, ... }:
{
  programs.git.enable = true;
  programs.git.ignores = [ "~/.gitignore_global" ];
  programs.git.userName = "hugosenari";
  programs.git.userEmail = "hugosenari@gmail.com";
  programs.git.aliases.s = "status - s";
  home.packages = with pkgs; [ gh ];
}
