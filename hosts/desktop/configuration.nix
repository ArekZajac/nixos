{ config, pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "desktop";

  # Boot: systemd-boot shares the ESP with Windows and auto-detects it.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Windows keeps the RTC in local time; match it to avoid clock skew.
  time.hardwareClockInLocalTime = true;

  # NVIDIA RTX 4070 (Ada)
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = { enable = true; enable32Bit = true; };
  hardware.nvidia = {
    modesetting.enable = true;   # required for Wayland
    open = true;                 # Ada supports the open modules; flip to false if you hit trouble
    nvidiaSettings = true;
    powerManagement.enable = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Niri
  programs.niri.enable = true;

  # Login: greetd + tuigreet launching a niri session.
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
      user = "greeter";
    };
  };

  # Minimal Wayland toolkit
  environment.systemPackages = with pkgs; [
    fuzzel              # app launcher
    alacritty           # terminal
    waybar              # status bar
    mako                # notifications
    swaybg              # wallpaper
    swaylock            # screen locker
    wl-clipboard
    xwayland-satellite  # lets X11 apps run under niri

    chromium
    discord
    spotify
  ];

  # Swaylock needs a PAM entry to authenticate, or it can't unlock.
  security.pam.services.swaylock = {};

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

  # Gaming
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfer.openFirewall = true;
  };
  programs.gamemode.enable = true;

  # No hibernate in a dual boot, so zram instead of a swap partition.
  zramSwap.enable = true;

  system.stateVersion = "25.11";
}
