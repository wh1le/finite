{ lib, pkgs, settings, ... }:

let
  # DNS is unavailable on first boot. Pi-hole tries to resolve during startup and fails.
  # Pre-pull the correct arm64 image to avoid any network lookups at runtime.
  # Reference digest with: docker manifest inspect pihole/pihole:latest
  digest = "sha256:ce924bd4f4439509a619c7a9002a5ebcceced98fc1866d991f929c3ebecd976a";

  pihole_image = pkgs.dockerTools.pullImage {
    imageName = "pihole/pihole";
    imageDigest = digest;
    finalImageName = "pihole/pihole";
    finalImageTag = "latest";
    os = "linux";
    arch = "arm64";

    # If the build fails with a “got:” hash, replace this value with the one Nix prints.
    sha256 = "sha256-vfY18TnW2A0zd/Q99fIVjEYBIQkJxpuHi6SGNHIE+oM=";
  };

  postinit = pkgs.writeShellScript "pi-hole-postinit.sh" ''
    set -euo pipefail

    # wait until container is reachable
    while ! ${pkgs.podman}/bin/podman exec -i pi-hole true 2>/dev/null; do
      sleep 1
    done

    # Pi-hole needs to download its blocklist once. It cannot resolve DNS yet because it is the DNS. Classic chicken-and-egg.
    # We cheat. Point it at Cloudflare just long enough to fetch the default block list, then switch back to the privacy bunker.
    ${pkgs.podman}/bin/podman exec -i pi-hole sh -lc 'printf "nameserver 1.1.1.1\nnameserver 1.0.0.1\n" >/etc/resolv.conf'
    ${pkgs.podman}/bin/podman exec -i pi-hole pihole -g
    ${pkgs.podman}/bin/podman exec -i pi-hole sh -lc 'printf "nameserver 127.0.0.1\nnameserver ::1\noptions edns0 trust-ad\n" >/etc/resolv.conf'
  '';
in
{
  services.resolved.enable = false;
  services.dnsmasq.enable = lib.mkForce false;

  networking.firewall.allowedTCPPorts = [ 53 80 ];
  networking.firewall.allowedUDPPorts = [ 53 67 ];

  systemd.services.docker-pi-hole.after = [ "unbound.service" ];
  systemd.services.docker-pi-hole.requires = [ "unbound.service" ];

  systemd.services.pi-hole-postinit = {
    description = "One-time post-init inside pi-hole container";
    after = [ "podman-pi-hole.service" ];
    requires = [ "podman-pi-hole.service" ];
    wantedBy = [ "multi-user.target" ];

    # run only once
    unitConfig.ConditionPathExists = "!/var/lib/pi-hole-postinit.stamp";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${postinit}";
      ExecStartPost = ''
        ${pkgs.coreutils}/bin/mkdir -p /var/lib
        ${pkgs.coreutils}/bin/touch /var/lib/pi-hole-postinit.stamp
      '';
    };
  };

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
      TZ = settings.TIMEZONE;
      DNSMASQ_USER = "root";
      FTLCONF_dns_upstreams = "${settings.STATIC_IP}#${settings.UNBOUND_PORT}";
      FTLCONF_rate_limit = "10000/60";
      QUERY_LOGGING = "false";
    };

    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cpus=0.5"
      "--memory=256m"
      "--network=host"
    ];
  };
}
