{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.dankMaterialShell.nixosModules.greeter
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.allowUnfree = true;

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
    pipewire = {
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
  };

  # Polkit
  security.polkit.enable = true;

  # XDG Portal
  xdg.portal = {
    enable = true;
    config = {
      #common.default = "*";
      common = {
        default = ["gnome" "gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira-sans
      fira-code
      roboto
      open-sans
      inter
      corefonts
      lilex
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      liberation_ttf
      dejavu_fonts
      fira-code-symbols
      material-symbols
      material-icons
      wqy_zenhei
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
    gamemode.enable = true;
    niri = {
      enable = true;
      package = pkgs.niri_git;
    };
    steam.enable = true;
    obs-studio = {
      enable = true;
      package = pkgs.obs-studio.override { cudaSupport = true; };
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
      ];
    };
    virt-manager.enable = true;
    dconf.enable = true;
    dankMaterialShell.greeter = {
      enable = true;
      compositor.name = "niri";
      configHome = "/home/xdenotte";
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  users.groups.libvirtd.members = [ "xdenotte" ];
  virtualisation.spiceUSBRedirection.enable = true;

  # System packages (one per line)
  environment.systemPackages = with pkgs; [
    # Core / utils
    git
    fastfetch
    htop
    stress-ng
    lshw
    bbe
    glib
    python3
    mesa-demos
    zip
    unzip

    # Wayland / WM
    xwayland-satellite
    brightnessctl
    kitty
    xdg-user-dirs
    wl-clipboard
    cliphist

    # Desktop & theming
    papirus-icon-theme
    bibata-cursors
    gnome-themes-extra
    nwg-look
    wallust
    swww
    font-manager
    gsettings-desktop-schemas
    qt6Packages.qt6ct
    qt6Packages.qt5compat
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtstyleplugin-kvantum
    matugen

    # Apps
    chromium
    vesktop
    telegram-desktop
    heroic
    prismlauncher
    spotify
    nemo-fileroller
    nemo-with-extensions
    file-roller
    kdePackages.kate
    libreoffice-qt
    loupe
    protonup-qt

    # Multimedia
    mpv
    cava
    pavucontrol
    ffmpeg
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi

    # Gaming
    mangohud

    # Other
    windsurf
  ];
}
