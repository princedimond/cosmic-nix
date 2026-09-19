{pkgs, ...}: {
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-GTK-Dark";
      package = pkgs.catppuccin-gtk;
    };
  };
}
