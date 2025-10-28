{
  pkgs,
  inputs,
  config,
  self,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.age.generateKey = true;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.defaultSopsFile = "${self}/secrets/default.yaml";
  sops.defaultSopsFormat = "yaml";

  sops.secrets = {
    user_password_file = {
      sopsFile = "${self}/secrets/default.yaml";
      key = "user_password";
      owner = "root";
      group = "root";
      mode = "0400";
      neededForUsers = true;
    };

    ssh_public_key = {
      sopsFile = "${self}/secrets/default.yaml";
      key = "ssh_public_key";
      owner = "root";
      group = "root";
      mode = "0400";
    };

    pihole_web_password = {
      sopsFile = "${self}/secrets/default.yaml";
      key = "pihole_web_password";
      owner = "root";
      group = "root";
      mode = "0400";
    }
  };

  sops.secrets.pihole_web_password.restartUnits = [
    "podman-pi-hole.service"
  ];

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
