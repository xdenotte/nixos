{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.xserver.enable = false;
  services.xserver.videoDrivers = ["nvidia"];
  nixpkgs.config.allowUnfree = true;

  # NVIDIA + Wayland
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

  # System cleanup
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };

  # Services
  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
    timesyncd.enable = true;
    gvfs.enable = true;
    displayManager.ly.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      extraConfig.pipewire."custom-tuning".context.properties."default.clock.min-quantum" = 1024;
    };
  };

  # Polkit
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira-sans roboto open-sans inter corefonts lilex
      noto-fonts noto-fonts-cjk-sans noto-fonts-cjk-serif
      noto-fonts-extra noto-fonts-emoji liberation_ttf
      dejavu_fonts fira-code-symbols
      material-symbols material-icons wqy_zenhei
    ];
  };

  # Networking
  networking.networkmanager.enable = true;

  # Icons
  xdg.icons.enable = true;

  # Programs
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    niri.enable = true;
    gamemode.enable = true;
    steam.enable = true;
    obs-studio = {
      enable = true;
      package = pkgs.obs-studio.override { cudaSupport = true; };
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs obs-backgroundremoval obs-pipewire-audio-capture
        obs-vaapi obs-gstreamer obs-vkcapture
      ];
    };
  };

  # System packages (grouped)
  environment.systemPackages = with pkgs; [

    # Core / utils
    git fastfetch htop stress-ng lshw bbe

    # Wayland / WM
    niri xwayland-satellite hypridle brightnessctl kitty xdg-user-dirs

    # Desktop & theming
    papirus-icon-theme bibata-cursors gnome-themes-extra nwg-look
    wallust swww font-manager gsettings-desktop-schemas
    qt6ct qt6Packages.qt5compat kdePackages.qtbase kdePackages.qtdeclarative
    kdePackages.qtstyleplugin-kvantum

    # Apps
    chromium discord vesktop telegram-desktop heroic prismlauncher spotify
    kdePackages.kate nemo libreoffice file-roller loupe

    # Multimedia
    mpv cava pavucontrol ffmpeg
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav gst_all_1.gst-vaapi

    # Gaming
    mangohud

    # Other
    polkit_gnome windsurf
  ];
}
