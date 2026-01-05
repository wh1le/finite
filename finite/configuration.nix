{ modulesPath
, settings
, ...
}:
{
  system.stateVersion = settings.STATE_VERSION;

  services.timesyncd.enable = true;
  services.timesyncd.servers = settings.TIMESYNCD_SERVERS;

  hardware.bluetooth.enable = false;

  home-manager.users.${settings.USERNAME} = { pkgs, ... }: {
    home.stateVersion = settings.STATE_VERSION;
    home.packages = [ pkgs.zsh ];

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

  nix.settings.trusted-public-keys = [
    "homepc:Zs+sokjN2dgbDQ4SbUH7zOw2I0E2Y/n+cilERPuZQFc="
  ];

  nix.settings.trusted-users = [ "root" settings.USERNAME ];

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
