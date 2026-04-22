{ ... }:

{
  virtualisation.oci-containers.containers = {

    beszel = {
      image = "henrygd/beszel:latest";
      autoStart = true;
      ports = [ "8090:8090" ];
      volumes = [ "/var/lib/beszel:/beszel_data" ];
    };

    beszel-agent = {
      image = "henrygd/beszel-agent:latest";
      autoStart = true;
      extraOptions = [ "--network=host" ];
      volumes = [
        "/run/podman/podman.sock:/var/run/docker.sock:ro"
      ];
      environment = {
        PORT = "45876";
        KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKX/gj7qUAtqniEMdgFj9yC8JvMFvLHafWQr7lTjmVlV";
        HUB_URL = "http://localhost:8090";
      };
    };

  };

  systemd.tmpfiles.rules = [
    "d /var/lib/beszel 0750 root root -"
  ];
}
