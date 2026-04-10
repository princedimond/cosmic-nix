{ config, pkgs, ... }:

{
  imports = [
    #./cosmic.nix
    ./evil-helix.nix
    ./gtk.nix
  ];
  home.username = "princedimond";
  home.homeDirectory = "/home/princedimond";
  home.stateVersion = "25.11";
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "princedimond";
      user.email = "princedimond@gmail.com";
      credential.helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };
  };

  /*
    # Force evil-helix as yazi editor
    home.file.".config/yazi/yazi.toml".text = ''
      [opener]
      edit = [
        { run = "hx %s", block = true, for = "unix" }
      ]
    '';
  */

  # Catppuccin Config
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "green";
    cursors.enable = true;
    zed.enable = true;
    thunderbird.enable = true;
    nvim.enable = true;

  };

  #enable catppuccin theme for these applications
  programs = {
    btop.enable = true;
    lazygit.enable = true;
    yazi.enable = true;
    television = {
      enable = true;
      enableBashIntegration = true;
    };
  };
  /*
    programs.yazi.enable = true;
    programs.btop.enable = true;
    programs.lazygit.enable = true;
    programs.zed.enable = true;
  */
}
