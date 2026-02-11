{ config, pkgs, lib, ... }:

{
  networking.hostName = "desktop";

  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = lib.mkDefault "25.11";
}
