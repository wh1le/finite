{ config, sops, self, SSH_PORT, USERNAME, ...}:

{
  sops.secrets = {
    ssh_public_key = {
      sopsFile = "${self}/secrets/default.yaml";
      key = "ssh_public_key";
      owner = "root";
      group = "root";
      mode = "0400";
    };
  };

  services.openssh = {
    enable = true;
    ports = [ SSH_PORT ];
    authorizedKeysFiles = [
      config.sops.secrets.ssh_public_key.path
    ];

    settings = {
      PasswordAuthentication = false;
    };
  };

  users.users.${USERNAME}.openssh.authorizedKeys.keys = [
    config.sops.secrets.ssh_public_key.path
  ];

  networking.firewall.allowedTCPPorts = [ SSH_PORT ];

  programs.ssh.startAgent = true;
}
