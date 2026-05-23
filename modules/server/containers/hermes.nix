{ ... }:

{
  virtualisation.oci-containers.containers.hermes = {
    image = "nousresearch/hermes-agent:latest";
    autoStart = true;
    cmd = [ "gateway" "run" ];
    ports = [
      "8642:8642"  # Gateway API
      "9119:9119"  # Web Dashboard
    ];
    volumes = [ "/var/lib/hermes:/opt/data" ];
    environment = {
      HERMES_DASHBOARD = "1";
      HERMES_DASHBOARD_HOST = "0.0.0.0";
      HERMES_DASHBOARD_PORT = "9119";
      HERMES_UID = "10000";
      HERMES_GID = "10000";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/hermes 0750 1000 1000 -"  # Owner must match HERMES_UID/HERMES_GID
  ];
}
