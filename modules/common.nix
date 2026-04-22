{ config, pkgs, lib, ... }:

{
  # System
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  # Packages
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
  ];

  # Networking
  networking.networkmanager.enable = true;
  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication = false;
    PermitRootLogin = "no";
  };

  # Users
  users.users.arek = {
    isNormalUser = true;
    description = "arek";
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMSoS4kqlQTPy/OWzzpyVLTTVnoAUQkJ+0QQn0OWPInS"
      ];
  };
  users.mutableUsers = true;
  security.sudo.wheelNeedsPassword = true;
}
