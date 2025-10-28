{
  lib,
  pkgs,
  STATIC_IP,
  UNBOUND_PORT,
  PIHOLE_PASSWORD,
  ...
}:

let

  # DNS is unavailable on first boot. Pi-hole tries to resolve during startup and fails.
  # Pre-pull the correct arm64 image to avoid any network lookups at runtime.
  # Reference digest with: docker manifest inspect pihole/pihole:latest
  digest = "sha256:ce924bd4f4439509a619c7a9002a5ebcceced98fc1866d991f929c3ebecd976a";

  pihole_image = pkgs.dockerTools.pullImage {
    imageName = "pihole/pihole";
    imageDigest = digest;
    finalImageName = "pihole/pihole";
    finalImageTag  = "latest";
    os   = "linux";
    arch = "arm64";

    # If the build fails with a “got:” hash, replace this value with the one Nix prints.
    sha256 = "sha256-vfY18TnW2A0zd/Q99fIVjEYBIQkJxpuHi6SGNHIE+oM=";
  };
in
{
  services.resolved.enable = false;
  services.dnsmasq.enable = lib.mkForce false;

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

    volumes = [
      "/pi-hole/data/etc-pihole:/etc/pihole"
      "/pi-hole/data/etc-dnsmasq.d:/etc/dnsmasq.d"
    ];

    environment = {
      TZ = "Europe/London";
      DNSMASQ_USER = "root";
      FTLCONF_dns_upstreams = "${STATIC_IP}#${UNBOUND_PORT}";
      WEBPASSWORD = PIHOLE_PASSWORD;
    };

    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cpus=0.5"
      "--memory=256m"
      "--network=host"
    ];
  };
}
