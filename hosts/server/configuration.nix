{ config, pkgs, lib, ... }:

{
  networking.hostName = "server";

  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/server
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.11";
}
