{ ... }:
{
  networking.firewall.enable = true;

  # Close all ports
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];
}
