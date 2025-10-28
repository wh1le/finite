{ config, sops, self, SSH_PORT, USERNAME, ...}:

{
  sops.secrets = {
    ssh_public_key = {
      sopsFile = "${self}/secrets/default.yaml";
      key = "ssh_public_key";
      owner = "root";
      group = "root";
      mode = "0644";
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

  system.activationScripts."zz-${USERNAME}-authorizedKeys".text = ''
    mkdir -p "/etc/ssh/authorized_keys.d";
    cp "${config.sops.secrets.ssh_public_key.path}" "/etc/ssh/authorized_keys.d/${USERNAME}";
    chmod +r "/etc/ssh/authorized_keys.d/${USERNAME}"
  '';

  networking.firewall.allowedTCPPorts = [ SSH_PORT ];

  programs.ssh.startAgent = true;
}
