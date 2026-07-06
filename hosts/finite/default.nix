{
  modulesPath,
  settings,
  ...
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

  # You can use trusted keys for deployment for extra security
  # nix.settings.trusted-public-keys = [ settings.TRUSTED_PUBLIC_KEYS ];
  nix.settings.require-sigs = false;

  nix.settings.trusted-users = [
    "root"
    settings.USERNAME
  ];

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix

    ../../modules/nixos/image.nix
    ../../modules/nixos/network.nix
    ../../modules/nixos/system.nix
    ../../modules/nixos/ssh.nix
    ../../modules/nixos/unbound.nix
    ../../modules/nixos/user.nix
    ../../modules/nixos/virtualisation.nix
    ../../modules/nixos/firewall.nix
    ../../modules/nixos/locales.nix

    ../../modules/nixos/containers/pi-hole.nix
  ];
}
