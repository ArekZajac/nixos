{ config, ... }:

{
  virtualisation.oci-containers.containers.stirling-pdf = {
    image = "stirlingtools/stirling-pdf:latest";
    autoStart = true;
    ports = [ "8080:8080" ];
    volumes = [
      "/var/lib/stirling-pdf/configs:/configs"
      "/var/lib/stirling-pdf/logs:/logs"
    ];
    environmentFiles = [
      config.age.secrets.stirling-user.path
      config.age.secrets.stirling-password.path
    ];
    environment = {
      DOCKER_ENABLE_SECURITY = "true";
      LANGS = "en_GB";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/stirling-pdf/configs 0750 root root -"
    "d /var/lib/stirling-pdf/logs 0750 root root -"
  ];
}
