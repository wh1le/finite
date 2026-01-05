{ settings
, ...
}:
{
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" settings.STATIC_IP ];
        port = settings.UNBOUND_PORT;

        access-control = settings.UNBOUND_SUBNETS;

        # Performance
        num-threads = 2;
        msg-cache-slabs = 2;
        rrset-cache-slabs = 2;
        infra-cache-slabs = 2;
        key-cache-slabs = 2;

        # Cache sizes
        msg-cache-size = "32m";
        rrset-cache-size = "64m";

        # Resilience
        prefetch-key = true;
        serve-expired = true;
        serve-expired-ttl = 86400;

        # Connection handling
        outgoing-range = 4096;
        num-queries-per-thread = 2048;

        # Based on recommended settings in https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;

        # Custom settings
        hide-identity = true;
        hide-version = true;

        # Zero log
        verbosity = 0;
        log-queries = "no";
        log-replies = "no";
        log-servfail = "no";

      };
      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "9.9.9.9@853#dns.quad9.net"
            "149.112.112.112@853#dns.quad9.net"
          ];
          forward-tls-upstream = true;
        }
      ];
    };
  };
}
