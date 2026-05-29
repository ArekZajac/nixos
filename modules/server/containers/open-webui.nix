{ config, ... }:

{
  virtualisation.oci-containers.containers.open-webui = {
    image = "ghcr.io/open-webui/open-webui:latest";
    autoStart = true;
    ports = [ "3000:8080" ];
    volumes = [ "/var/lib/open-webui:/app/backend/data" ];
    environmentFiles = [
      config.age.secrets.open-webui-api-key.path
    ];
    environment = {
      OPENAI_API_BASE_URL = "http://hermes:8642/v1"; # Via Podman default DNS
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/open-webui 0750 1000 1000 -"
  ];
}
