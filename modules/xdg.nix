{ pkgs, ... }:
{
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
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };
}
