{ config, USERNAME, SSH_PUBLIC_KEY, self, ...}:
{
  users.mutableUsers = true;

  users.users.${USERNAME} = {
    isNormalUser = true;

    password = "hackme";

    extraGroups = [ "wheel" "input" ];

    openssh.authorizedKeys.keys = [ SSH_PUBLIC_KEY ];
  };
}
