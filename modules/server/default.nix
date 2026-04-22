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
  virtualisation.oci-containers.backend = "podman";

  # Automatic rebuild
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
      8090  # Beszel
    ];
  };

  # Power management
  services.logind.lidSwitch = "ignore";
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
  '';
}
