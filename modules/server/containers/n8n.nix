{ ... }:

{
  virtualisation.oci-containers.containers.n8n = {
    image = "n8nio/n8n:latest";
    autoStart = true;
    ports = [ "5678:5678" ];
    volumes = [ "/var/lib/n8n:/home/node/.n8n" ];
    environment = {
      N8N_HOST = "0.0.0.0";
      N8N_PORT = "5678";
      N8N_PROTOCOL = "http";
      GENERIC_TIMEZONE = "Europe/London";
      TZ = "Europe/London";
    };
  };

  # Create the data directory on the host before the container starts.
  # n8n runs as the 'node' user (uid 1000) inside the container,
  # so the directory needs to be owned by uid 1000 to be writable.
  systemd.tmpfiles.rules = [
    "d /var/lib/n8n 0750 1000 1000 -"
  ];
}
