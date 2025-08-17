{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./../modules/system.nix
    ./../modules/home.nix
    ./../modules/xdg.nix
    ./../modules/stylix.nix
  ];

  networking.hostName = "hestia";
  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.plymouth.enable = true;
<<<<<<< HEAD
  boot.plymouth.theme = "bgrt";
  boot.kernelParams = [ "quiet" ];
=======
>>>>>>> c9ec1fe352bc1751d72d982acf551a4ff0b6810c
  boot.plymouth.themePackages = [ pkgs.plymouth ];

  boot.initrd.systemd.enable = true;

  users.users.xdenotte = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
    packages = with pkgs; [ home-manager ];
  };

  i18n.defaultLocale = "ru_RU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  time.timeZone = "Europe/Berlin";

  system.stateVersion = "25.05";
}
