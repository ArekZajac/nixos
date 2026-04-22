{ config, pkgs, lib, ... }:

{
  imports = [
    ./containers
  ];

  # Container runtime
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;  # Allows 'docker' as CLI alias for podman
    defaultNetwork.settings.dns_enabled = true;
  };

  # Set podman as backend for all oci-containers declarations
  virtualisation.oci-containers.backend = "podman";

  # Automatically pull latest config from GitHub and rebuild
  system.autoUpgrade = {
    enable = true;
    flake = "github:ArekZajac/nixos/live#server";
    dates = "04:00";
  };

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      5678  # n8n
    ];
  };
}
