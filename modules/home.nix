{ pkgs, inputs, ... }: {
  home-manager.users.xdenotte = {
    home.homeDirectory = "/home/xdenotte";
    home.stateVersion = "25.05";

    imports = [
      inputs.dms.homeModules.dank-material-shell
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

    programs.dank-material-shell = {
      enable = true;
      quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };


    gtk = {
      enable = true;
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
      gtk3 = {
        extraConfig.gtk-application-prefer-dark-theme = true;
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
      GTK_THEME = "adw-gtk3-dark";
    };
  };
}

