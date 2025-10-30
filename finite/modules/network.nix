{lib, settings, ...}:

{
  networking.hostName = "finite";

  # Point DNS resolution to Pi-hole
  networking.nameservers = [ "127.0.0.1" ];

  networking.wireless.enable = false;

  # Lock ip address
  networking.defaultGateway = {
    address = settings.ROUTER_IP;
    interface = "eth0";
  };

  # disable dynamic IP assignment
  networking.useDHCP = lib.mkForce false;
  networking.interfaces.eth0 = {
    useDHCP = lib.mkForce false;

    ipv4.addresses = [
      {
        address = settings.STATIC_IP;
        prefixLength = 24;
      }
    ];
  };
}
