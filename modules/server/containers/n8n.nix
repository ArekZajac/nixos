{ config, ... }:

{
  virtualisation.oci-containers.containers.n8n = {
    image = "n8nio/n8n:latest";
    autoStart = true;
    ports = [ "5678:5678" ];
    volumes = [ "/var/lib/n8n:/home/node/.n8n" ];
    environmentFiles = [
      config.age.secrets.n8n-user.path
      config.age.secrets.n8n-password.path
    ];
    environment = {
      N8N_HOST = "0.0.0.0";
      N8N_PORT = "5678";
      N8N_PROTOCOL = "http";
      N8N_SECURE_COOKIE = "false";
      GENERIC_TIMEZONE = "Europe/London";
      TZ = "Europe/London";
      N8N_BASIC_AUTH_ACTIVE = "true";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/n8n 0750 1000 1000 -"
  ];
}
