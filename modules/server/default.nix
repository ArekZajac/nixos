{ config, pkgs, lib, ... }:

{
  imports = [
    ./containers
  ];

  # Agenix
  age.secrets = {
    beszel-key.file        = ../../secrets/beszel-key.age;
    beszel-token.file      = ../../secrets/beszel-token.age;
    n8n-user.file          = ../../secrets/n8n-user.age;
    n8n-password.file      = ../../secrets/n8n-password.age;
    stirling-user.file     = ../../secrets/stirling-user.age;
    stirling-password.file = ../../secrets/stirling-password.age;
  };

  # Container runtime
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  virtualisation.oci-containers.backend = "podman";

  # Automatic rebuild
  system.autoUpgrade = {
    enable = true;
    flake = "github:ArekZajac/nixos/live#server";
    allowReboot = false;
    operation = "switch";
    dates = "04:00";
  };

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      5678  # n8n
      8090  # Beszel
      8080  # Stirling PDF
      8642  # Hermes Agent Gateway
      9119  # Hermes Agent Dashboard
    ];
  };

  # Power management
  services.logind.lidSwitch = "ignore";
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
  '';
}
