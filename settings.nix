{
  STATE_VERSION = "25.05";
  SYSTEM = "aarch64-linux";

  USERNAME = "astronaut";
  USER_PASSWORD = "hackme";

  SSH_PORT = 1234;
  SSH_PUBLIC_KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJDc8RAeF+LoThFl5ArIVRVB2MRFbaG2nTGiXI3mayA7 wh1le@homepc";

  TIMEZONE = "Europe/Lisbon";

  ROUTER_IP = "192.168.50.1";
  STATIC_IP = "192.168.50.2";

  # sudo nix-store --generate-binary-cache-key homepc /etc/nix/signing-key /etc/nix/signing-key.pub
  TRUSTED_PUBLIC_KEYS = [ "YOUR_MACHINE_KEY_HERE" ];

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
