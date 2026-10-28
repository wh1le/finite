{ settings, ... }:
{
  assertions = [
    {
      assertion = settings.SSH_PUBLIC_KEY != "";
      message = "settings.nix: set SSH_PUBLIC_KEY to your own key, ssh password login is disabled";
    }
  ];

  users.mutableUsers = true;

  users.users.${settings.USERNAME} = {
    isNormalUser = true;

    password = settings.USER_PASSWORD;

    extraGroups = [ "wheel" "input" ];

    openssh.authorizedKeys.keys = [ settings.SSH_PUBLIC_KEY ];
  };
}
