{ config, self, SSH_PORT, USERNAME, ...}:

{
  services.openssh = {
    enable = true;
    ports = [ SSH_PORT ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  networking.firewall.allowedTCPPorts = [ SSH_PORT ];

  programs.ssh.startAgent = true;
}
