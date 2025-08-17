
{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nixpkgs.config.allowUnfree = true;
  services.power-profiles-daemon.enable = true;
  services.xserver.enable = false;
  services.xserver.videoDrivers = ["nvidia"];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true;
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:05:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 5d";
  };

  systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
    fira-sans
    roboto
    open-sans
    noto-fonts
    inter
    corefonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-extra
    lilex
    noto-fonts-emoji
    liberation_ttf
    dejavu_fonts
    fira-code-symbols
    material-symbols
    material-icons
    wqy_zenhei
  ];
};

  # Audio and Some settings
  services.upower.enable = true;
  security.polkit.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    extraConfig = {
      pipewire = {
       "bullshit-sound" = {
         "context.properties" = {
           "default.clock.min-quantum" = 1024;
         };
       };
      };
    };
  };

  networking.networkmanager.enable = true;
  services.timesyncd.enable = true;
  services.gvfs.enable = true;

  services.displayManager.ly.enable = true;
  xdg.icons.enable = true;

  environment.systemPackages = with pkgs; [
    git
    chromium
    discord
    vesktop
    niri
    networkmanagerapplet
    kdePackages.kate
    fastfetch
    kitty
    xwayland-satellite
    brightnessctl
    nemo
    papirus-icon-theme
    bibata-cursors
    gnome-themes-extra
    nwg-look
    pavucontrol
    telegram-desktop
    qt6ct
    swww
    wallust
    cava
    xdg-user-dirs
    qt6Packages.qt5compat
    loupe
    libsForQt5.qt5.qtgraphicaleffects
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtstyleplugin-kvantum
    polkit_gnome
    hypridle
    upower
    heroic
    prismlauncher
    spotify
    power-profiles-daemon
    mangohud
    htop
    windsurf
    mpv
    file-roller
    stress-ng
    font-manager
    lshw
    glib
    ffmpeg
    bbe
    libreoffice
    gsettings-desktop-schemas
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  programs.niri.enable = true;
  programs.gamemode.enable = true;
  programs.steam.enable = true;
  programs.obs-studio = {
    enable = true;

    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
      ];
    };
}
