{ lib, settings, ... }:

{
  networking = {
    hostName = "finite";

    # Point DNS resolution to Pi-hole
    nameservers = [ "127.0.0.1" ];

    wireless.enable = false;

    # Lock ip address
    defaultGateway = {
      address = settings.ROUTER_IP;
      interface = "eth0";
    };

    # disable dynamic IP assignment
    useDHCP = lib.mkForce false;
    interfaces.eth0 = {
      useDHCP = lib.mkForce false;

      ipv4.addresses = [
        {
          address = settings.STATIC_IP;
          prefixLength = 24;
        }
      ];
    };
  };
}
