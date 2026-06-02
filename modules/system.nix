{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.dms.nixosModules.greeter
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.allowUnfree = true;
  powerManagement.enable = true;
  hardware.enableAllFirmware = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    prime = {
      offload = {
      enable = true;
      enableOffloadCmd = true;
    };
      amdgpuBusId = "PCI:5:0:0";
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
    accounts-daemon.enable = true;
    upower.enable = true;
    timesyncd.enable = true;
    gvfs.enable = true;
    auto-cpufreq = {
      enable = true;
      settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
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

  # Security
  security.polkit.enable = true;
  security.rtkit.enable = true;

  # XDG Portal
  xdg.portal = {
    enable = true;
    config = {
      niri.default = ["gnome" "gtk"];
      common.default = ["gtk"];
      obs.default = "gnome";
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
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
    firefox.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
    nix-ld.enable = true;
    gamemode.enable = true;
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
    steam.enable = true;
    gpu-screen-recorder.enable = true;
    virt-manager.enable = true;
    dconf.enable = true;
    dank-material-shell.greeter = {
      enable = true;
      compositor.name = "niri";
      configHome = "/home/xdenotte";
    };
    obs-studio = {
      enable = true;

    # optional Nvidia hardware acceleration
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
  };

  # VM
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

  # Swap
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8*1024;
    priority = 0;
  }];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    priority = 100;
    memoryPercent = 30;
  };

  nix.settings = {
    substituters = [
      "https://niri-nix.cachix.org"
    ];
    trusted-public-keys = [
      "niri-nix.cachix.org-1:SvFtqpDcf7Sm1SMJdby1/+Y+6f3Yt3/3PMcSTKPJNJ0="
    ];
  };

  # System packages (one per line)
  environment.systemPackages = with pkgs; [
    # Core / utils
    git
    fastfetch
    htop
    stress-ng
    lshw
    glib
    python3
    mesa-demos

    # Wayland / WM
    xwayland-satellite-unstable
    brightnessctl
    foot
    xdg-user-dirs
    wl-clipboard
    cliphist

    # Desktop & theming
    papirus-icon-theme
    bibata-cursors
    gnome-themes-extra
    nwg-look
    font-manager
    gsettings-desktop-schemas
    qt6Packages.qt6ct
    qt6Packages.qt5compat
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtstyleplugin-kvantum
    matugen

    # Apps and Games
    gpu-screen-recorder-gtk
    vesktop
    telegram-desktop
    heroic
    prismlauncher
    spotify
    nautilus
    file-roller
    kdePackages.kate
    kdePackages.kdenlive
    loupe
    protonplus
    kdiskmark
    libreoffice-qt
    inputs.blender-bin.packages.${stdenv.hostPlatform.system}.default

    # Multimedia
    mpv
    audacity
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
