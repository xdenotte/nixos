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
  systemd.user.services.niri-flake-polkit.enable = false;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "595.45.04";
      sha256_64bit = "sha256-zUllSSRsuio7dSkcbBTuxF+dN12d6jEPE0WgGvVOj14=";
      sha256_aarch64 = "sha256-jl6lQWsgF6ya22sAhYPpERJ9r+wjnWzbGnINDpUMzsk=";
      openSha256 = "sha256-uqNfImwTKhK8gncUdP1TPp0D6Gog4MSeIJMZQiJWDoE=";
      settingsSha256 = "sha256-Y45pryyM+6ZTJyRaRF3LMKaiIWxB5gF5gGEEcQVr9nA=";
      persistencedSha256 = "sha256-5FoeUaRRMBIPEWGy4Uo0Aho39KXmjzQsuAD9m/XkNpA=";
    };

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
    accounts-daemon.enable = true;
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

  # Security
  security.polkit.enable = true;

  # XDG Portal
  xdg.portal = {
    enable = true;
    config = {
      niri.default = ["gtk" "gnome"];
      common.default = ["gtk"];
      obs.default = "gnome";
    };
    extraPortals = with pkgs; [
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
  };

  nix.settings = {
    substituters = [
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 30;
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
    xwayland-satellite-unstable
    brightnessctl
    kitty
    xdg-user-dirs
    wl-clipboard
    cliphist
    grim
    slurp

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

    # Apps and Games
    chromium
    gpu-screen-recorder-gtk
    vesktop
    telegram-desktop
    heroic
    prismlauncher
    spotify
    nemo-fileroller
    nemo-with-extensions
    file-roller
    kdePackages.kate
    loupe
    protonplus
    kdiskmark

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
