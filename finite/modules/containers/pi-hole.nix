{
  config,
  lib,
  sops,
  STATIC_IP,
  UNBOUND_PORT,
  ...
}:

let
  PI_HOLE_PASSWORD_PATH = "/run/private/pihole_web_password";

  # We can't connect to internet because DNS is not available on first boot
  # Docker container fails to start because of the DNS error the
  # solution is to pre-build image to do so we need to get digest
  # matching arm64 architecture
  # $ docker manifest inspect pihole/pihole:latest

  digest = "sha256:ce924bd4f4439509a619c7a9002a5ebcceced98fc1866d991f929c3ebecd976a";

  pihole_image = pkgs.dockerTools.pullImage {
    imageName = "pihole/pihole";
    imageDigest = DIGEST;
    finalImageName = "pihole/pihole";
    finalImageTag  = "latest";
    os   = "linux";
    arch = "arm64";
  };
in
{
  services.resolved.enable = false;
  services.dnsmasq.enable = lib.mkForce false;

  sops.secrets.pihole_web_password.restartUnits = [
    "podman-pi-hole.service"
  ];

  networking.firewall.allowedTCPPorts = [ 53 80 ];
  networking.firewall.allowedUDPPorts = [ 53 67 ];

  systemd.tmpfiles.rules = [
    "d /pi-hole/data/etc-pihole     0755 root root - -"
    "d /pi-hole/data/etc-dnsmasq.d  0755 root root - -"
  ];

  virtualisation.oci-containers.containers.pi-hole = {
    image = "pihole/pihole:latest";
    imageFile = pihole_image;
    autoStart = true;


    # ports = [
    #   "53:53/tcp"
    #   "53:53/udp"
    #   "80:80/tcp"
    # ];

    volumes = [
      "/pi-hole/data/etc-pihole:/etc/pihole"
      "/pi-hole/data/etc-dnsmasq.d:/etc/dnsmasq.d"
      "${config.sops.secrets.pihole_web_password.path}:${PI_HOLE_PASSWORD_PATH}"
    ];

    environment = {
      TZ = "Europe/London";
      DNSMASQ_USER = "root";
      FTLCONF_dns_upstreams = "${STATIC_IP}#${UNBOUND_PORT}";
      WEBPASSWORD_FILE = PI_HOLE_PASSWORD_PATH;
    };

    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cpus=0.5"
      "--memory=256m"
      "--network=host"
    ];
  };
}
