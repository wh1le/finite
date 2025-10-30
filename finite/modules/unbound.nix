{
  settings,
  ...
}:
{
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" settings.STATIC_IP ];
        port = settings.UNBOUND_PORT;

        access-control = settings.UNBOUND_SUBNETS;

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
