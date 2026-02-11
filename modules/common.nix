{ config, pkgs, lib, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
  ];

  networking.networkmanager.enable = true;

  services.openssh.enable = true;
  users.mutableUsers = true;

  users.users.arek = {
    isNormalUser = true;
    description = "arek";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  security.sudo.wheelNeedsPassword = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
