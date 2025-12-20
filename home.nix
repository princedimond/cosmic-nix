{ config, pkgs, ... }:

{
  imports = [
    #./plasma.nix
    ./evil-helix.nix
  ];
  home.username = "princedimond";
  home.homeDirectory = "/home/princedimond";
  #programs.git.enable = true;
  home.stateVersion = "25.11";
  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {
      credential.helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };
    settings = {
      user.name = "princedimond";
      user.email = "princedimond@gmail.com";
    };
  };
}
