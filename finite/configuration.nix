{
  modulesPath,
  pkgs,
  TIMESYNCD_SERVERS,
  STATE_VERSION,
  ...
}:
{
  system.stateVersion = STATE_VERSION;

  services.timesyncd.enable = true;
  services.timesyncd.servers = TIMESYNCD_SERVERS;

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix

    ./modules/sops.nix

    ./modules/image.nix
    ./modules/network.nix
    ./modules/system.nix
    ./modules/ssh.nix
    ./modules/unbound.nix
    ./modules/user.nix
    ./modules/virtualisation.nix
    ./modules/firewall.nix
    ./modules/locales.nix

    ./modules/containers/pi-hole.nix
  ];
}
