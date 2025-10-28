{
  STATIC_IP,
  UNBOUND_PORT,
  ...
}:
{
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" STATIC_IP ];
        port = UNBOUND_PORT;

        access-control = [ "127.0.0.1/32 allow" "192.168.1.0/24 allow" ];

        # Based on recommended settings in https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;

        # Custom settings
        hide-identity = true;
        hide-version = true;

      };

      forward-zone = [
        # Example config with quad9
        {
          name = ".";
          forward-addr = [
            "9.9.9.9#dns.quad9.net"
            "149.112.112.112#dns.quad9.net"
          ];
          forward-tls-upstream = true;  # Protected DNS
        }
      ];
    };
  };
}
