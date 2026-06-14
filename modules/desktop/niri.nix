{ config, pkgs, lib, ... }:
{
  programs.niri.enable = true;

  # Login: greetd + tuigreet launching a niri session.
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
      user = "greeter";
    };
  };

  # XDG portals: screen sharing + file pickers.
  # The niri module wires the screencast portal; gtk covers file dialogs.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # System-level Wayland session bits.
  environment.systemPackages = with pkgs; [
    swaybg              # wallpaper
    swaylock            # screen locker (needs the PAM entry below)
    xwayland-satellite  # lets X11 apps (Steam, some games) run under niri
    wl-clipboard
  ];

  # Swaylock needs a PAM entry to authenticate, or it can't unlock.
  security.pam.services.swaylock = { };

  # Polkit agent for GUI privilege prompts.
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
  };

  # Bluetooth (controllers, headsets) with a tray applet.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # dconf is required for GTK theming set via Home Manager.
  programs.dconf.enable = true;
}
