{ settings, ...}:
{
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "overlay2";
      daemon.settings.experimental = true;
    };

    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    oci-containers.backend = "podman";
  };

  users.users.${settings.USERNAME}.extraGroups = [ "docker" "kvm" ];
}
