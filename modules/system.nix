{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  ############################################################
  ## Nix
  ############################################################

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;

    substituters = [
      "https://niri-nix.cachix.org"
      "https://noctalia.cachix.org"
    ];

    trusted-public-keys = [
      "niri-nix.cachix.org-1:SvFtqpDcf7Sm1SMJdby1/+Y+6f3Yt3/3PMcSTKPJNJ0="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };

  ############################################################
  ## Boot
  ############################################################

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ############################################################
  ## Hardware
  ############################################################

  powerManagement.enable = true;

  hardware = {
    bluetooth.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;

      powerManagement = {
        enable = true;
        finegrained = true;
      };

      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;

      prime = {
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";

        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };
  };

  ############################################################
  ## Services
  ############################################################

  services = {
    xserver.videoDrivers = [ "nvidia" ];

    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    upower.enable = true;
    timesyncd.enable = true;
    gvfs.enable = true;

    pipewire = {
      enable = true;

      alsa.enable = true;
      pulse.enable = true;
    };
  };

  ############################################################
  ## Security
  ############################################################

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  ############################################################
  ## Networking
  ############################################################

  networking.networkmanager.enable = true;

  ############################################################
  ## XDG
  ############################################################

  xdg = {
    icons.enable = true;

    portal = {
      enable = true;
      xdgOpenUsePortal = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
    };
  };

  ############################################################
  ## Fonts
  ############################################################

  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      jetbrains-mono

      liberation_ttf
      dejavu_fonts

      inter
      roboto

      source-sans
      source-serif
      source-code-pro

      corefonts
      material-symbols
      lilex
    ];

  fontconfig = {
    enable = true;
    antialias = true;
    hinting.enable = true;

    defaultFonts = {
      sansSerif = [ "Noto Sans" "Liberation Sans" ];
      serif = [ "Noto Serif" "Liberation Serif" ];
      monospace = [ "JetBrainsMono Nerd Font" "DejaVu Sans Mono" ];
      };
    };
  };

  ############################################################
  ## Programs
  ############################################################

  programs = {
    firefox.enable = true;

    appimage = {
      enable = true;
      binfmt = true;
    };

    nix-ld.enable = true;
    gamemode.enable = true;
    dconf.enable = true;

    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };

    steam.enable = true;
    gpu-screen-recorder.enable = true;
    virt-manager.enable = true;

    noctalia-greeter = {
      enable = true;
      package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };

  ############################################################
  ## Virtualization
  ############################################################

  virtualisation = {
    spiceUSBRedirection.enable = true;

    libvirtd = {
      enable = true;

      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
  };

  users.groups.libvirtd.members = [ "xdenotte" ];

  ############################################################
  ## Memory
  ############################################################

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    priority = 100;
    memoryPercent = 30;
  };

  ############################################################
  ## Packages
  ############################################################

  environment.systemPackages = with pkgs; [
    # Core
    git
    fastfetch
    htop
    python3
    stress-ng

    # Wayland
    brightnessctl
    cliphist
    foot
    wl-clipboard
    xwayland-satellite-unstable

    # Theming
    bibata-cursors
    font-manager
    gnome-themes-extra
    kdePackages.qtstyleplugin-kvantum
    matugen
    nwg-look
    papirus-icon-theme
    qt6Packages.qt6ct

    # Applications
    audacity
    cava
    file-roller
    gpu-screen-recorder-gtk
    heroic
    inputs.blender-bin.packages.${pkgs.stdenv.hostPlatform.system}.default
    kdiskmark
    kdePackages.kate
    kdePackages.kdenlive
    libreoffice-qt
    loupe
    mpv
    nautilus
    pavucontrol
    prismlauncher
    protonplus
    spotify
    telegram-desktop
    equibop
    goverlay

    # Multimedia
    ffmpeg

    # Gaming
    mangohud

    # Other
    windsurf
  ];
}
