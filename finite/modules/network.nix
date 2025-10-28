{lib, STATIC_IP, ROUTER_IP, UNBOUND_PORT, ...}:

{
  networking.hostName = "finite";

  # Point DNS resolution to Pi-hole
  networking.nameservers = [ "127.0.0.1" ];

  # Disable wi-fi
  networking.wireless.enable = false;

  # Lock ip address
  networking.defaultGateway = {
    address = ROUTER_IP;
    interface = "eth0";
  };

  # Enable ethernet & disable dynamic IP assignment
  networking.useDHCP = lib.mkForce false;
  networking.interfaces.eth0 = {
    useDHCP = lib.mkForce false;

    ipv4.addresses = [
      {
        address = STATIC_IP;
        prefixLength = 24;
      }
    ];
  };
}
