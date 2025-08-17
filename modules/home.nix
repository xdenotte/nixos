{ pkgs, ... }: {
  home-manager.users.xdenotte = {
    home.homeDirectory = "/home/xdenotte";
    home.stateVersion = "25.05";

    home.packages = with pkgs; [
<<<<<<< HEAD
=======
      papirus-icon-theme
      colloid-gtk-theme
>>>>>>> c9ec1fe352bc1751d72d982acf551a4ff0b6810c
      pkgs.kdePackages.breeze
      pkgs.qt6Packages.qtstyleplugin-kvantum
      pkgs.qt6ct
      bibata-cursors
    ];

<<<<<<< HEAD
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    gtk = {
      enable = true;
      theme = {
        name = "Colloid-Dark";
        package = pkgs.colloid-gtk-theme;
      };
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

=======
>>>>>>> c9ec1fe352bc1751d72d982acf551a4ff0b6810c
    xdg.desktopEntries.spotify = {
      name = "Spotify";
      genericName = "Music Player";
      comment = "Listen to music";
      exec = "spotify --force-device-scale-factor=1.25";
      icon = "spotify";
      terminal = false;
      type = "Application";
      categories = [ "Audio" "Music" "Player" "AudioVideo" ];
    };
<<<<<<< HEAD

    home.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt6ct";
      QT_STYLE_OVERRIDE = "Breeze";
      XCURSOR_THEME = "Bibata-Modern-Classic";
    };
=======
>>>>>>> c9ec1fe352bc1751d72d982acf551a4ff0b6810c
  };
}
