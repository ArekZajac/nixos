{ config, pkgs, lib, ... }:

{
  networking.hostName = "server";

  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = lib.mkDefault "25.11";
}
