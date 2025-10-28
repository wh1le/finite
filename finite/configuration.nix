{
  modulesPath,
  TIMESYNCD_SERVERS,
  STATE_VERSION,
  USERNAME,
  ...
}:
{
  system.stateVersion = STATE_VERSION;

  services.timesyncd.enable = true;
  services.timesyncd.servers = TIMESYNCD_SERVERS;

  hardware.bluetooth.enable = false;

  home-manager.users.${USERNAME} = { pkgs, ... }: {

    home.stateVersion = STATE_VERSION;
    home.packages  = [ pkgs.zsh ];

    programs.zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "dirhistory"
          "history"
        ];
      };
    };
  };

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix

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
