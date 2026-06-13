{ config, pkgs, lib, ... }:

{
  networking.hostName = "server";

  imports = [
    ./hardware-configuration.nix
    ../../modules/server
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
