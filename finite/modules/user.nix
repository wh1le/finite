{ config, USERNAME, ...}:
{
  users.users.${USERNAME} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" ];
    hashedPasswordFile = config.sops.user_password_file.path;
  };
}
