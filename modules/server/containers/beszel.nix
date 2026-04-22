{ ... }:

{
  virtualisation.oci-containers.containers = {

    beszel = {
      image = "henrygd/beszel:latest";
      autoStart = true;
      ports = [ "8090:8090" ];
      volumes = [
        "/var/lib/beszel:/beszel_data"
        "/var/lib/beszel-socket:/beszel_socket"
      ];
      environment = {
        APP_URL = "http://localhost:8090";
      };
    };

    beszel-agent = {
      image = "henrygd/beszel-agent:latest";
      autoStart = true;
      extraOptions = [ "--network=host" ];
      volumes = [
        "/run/podman/podman.sock:/var/run/docker.sock:ro"
        "/var/lib/beszel-socket:/beszel_socket"
      ];
      environment = {
        LISTEN = "/beszel_socket/beszel.sock";
        KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKX/gj7qUAtqniEMdgFj9yC8JvMFvLHafWQr7lTjmVlV";
        TOKEN = "a080-1b1b22be68-135c-3c402c4475";
      };
    };

  };

  systemd.tmpfiles.rules = [
    "d /var/lib/beszel 0750 root root -"
    "d /var/lib/beszel-socket 0750 root root -"
  ];
}
