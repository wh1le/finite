{ settings, ...}:

{
  services.openssh = {
    enable = true;
    ports = [ settings.SSH_PORT ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  networking.firewall.allowedTCPPorts = [ settings.SSH_PORT ];

  programs.ssh.startAgent = true;
}
