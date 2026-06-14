{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop
  ];

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
    open = true;                 # Ada supports the open modules
    nvidiaSettings = true;
    powerManagement.enable = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Zsh
  programs.zsh.enable = true;
  users.users.arek.shell = pkgs.zsh;

  # No hibernate in a dual boot, so zram instead of a swap partition.
  zramSwap.enable = true;

  users.users.arek.initialPassword = "changeme";
  system.stateVersion = "25.11";
}
