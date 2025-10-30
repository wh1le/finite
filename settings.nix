{ ...}:
{
  STATE_VERSION = "25.05";
  SYSTEM = "aarch64-linux";

  USERNAME = "astronaut";
  USER_PASSWORD = "hackme";

  SSH_PORT = 1234;
  SSH_PUBLIC_KEY = "ssh-rsa AAAAB3Nz.. your key here";

  TIMEZONE = "Europe/Lisbon";

  ROUTER_IP = "192.168.50.1";
  STATIC_IP = "192.168.50.2";

  # Cloudflare NTP usage: https://developers.cloudflare.com/time-services/ntp/usage/#linux
  # Unbound fails on first boot if system clock is wrong (TLS cert validation).
  # Allow outbound NTP temporarily so the clock syncs and Unbound can start correctly.
  TIMESYNCD_SERVERS = [ "162.159.200.1" "162.159.200.123" ];

  UNBOUND_SUBNETS = [
    "127.0.0.1/32 allow"
    "192.168.1.0/24 allow"
    "192.168.50.0/24 allow"
  ];
  UNBOUND_PORT = "5335";
}