{ config, sops, USERNAME, self, ...}:
{
  sops.secrets.user_password_file = {
    sopsFile = "${self}/secrets/default.yaml";
    key = "user_password";
    owner = "root";
    group = "root";
    mode = "0400";
    neededForUsers = true;
  };

  users.users.${USERNAME} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" ];
    hashedPasswordFile = config.sops.secrets.user_password_file.path;
  };
}
