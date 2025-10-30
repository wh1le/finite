{  settings, ...}:
{
  users.mutableUsers = true;

  users.users.${settings.USERNAME} = {
    isNormalUser = true;

    password = settings.USER_PASSWORD;

    extraGroups = [ "wheel" "input" ];

    openssh.authorizedKeys.keys = [ settings.SSH_PUBLIC_KEY ];
  };
}
