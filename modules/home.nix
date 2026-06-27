{ pkgs, inputs, ... }: {
  home-manager.users.xdenotte = {
    home.homeDirectory = "/home/xdenotte";
    home.stateVersion = "25.05";

    imports = [
      inputs.noctalia.homeModules.default
    ];

    home.packages = with pkgs; [
      colloid-gtk-theme
      pkgs.kdePackages.breeze
      bibata-cursors
      adw-gtk3
    ];

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    programs = {
      noctalia = {
        enable = true;
      };
    };

    gtk = {
      enable = true;
      gtk4.theme = null;
      iconTheme = {
        name = "Papirus";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "peach";
        };
      };
      font = {
        name = "Adwaita Sans";
        package = pkgs.adwaita-fonts;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qt6ct";
      style = {
        name = "Breeze";
        package = pkgs.kdePackages.breeze;
      };
    };

    home.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt6ct";
      QT_STYLE_OVERRIDE = "Breeze";
      XCURSOR_THEME = "Bibata-Modern-Classic";
      GTK_THEME = "adw-gtk3";
    };
  };
}
