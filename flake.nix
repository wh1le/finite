{
  description = "Finite. Privacy-focused DNS on Raspberry Pi using NixOS, Unbound, and Pi-hole";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    {
      nixConfig = {
        extra-experimental-features = [ "nix-command" "flakes" ];
      };

      nixosConfigurations = {
        finite = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./finite/configuration.nix
            home-manager.nixosModules.home-manager
          ];
          specialArgs = {
            inherit self inputs;

            USERNAME = "astronaut";
            STATE_VERSION = "25.05";
            STATIC_IP = "192.168.1.253";
            ROUTER_IP = "192.168.1.254";
            UNBOUND_PORT = "5335";

            # Cloudflare NTP usage: https://developers.cloudflare.com/time-services/ntp/usage/#linux
            # Unbound fails on first boot if system clock is wrong (TLS cert validation).
            # Allow outbound NTP temporarily so the clock syncs and Unbound can start correctly.
            TIMESYNCD_SERVERS = [ "162.159.200.1" "162.159.200.123" ];

            SSH_PORT = 1234;
            PIHOLE_PASSWORD = "hackme";
            SSH_PUBLIC_KEY = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/rer3XWit5BHIStDlznJaDpQCsGbEk7FzjhZqcm0w8y1iDBWWn4+V0BHvnMd321xFP7ca+XInhD7Vv/q8+D+qJDFtTAZn4/eVvbThgf2oNAibqqgtvjvBTY+DJsQBUe6yOxmUyOYGiDEzPrcw7XwWAznVpJQoMl66KYDv88J//LTPp2Lm0Kz75oyEKf1VNL5A+YPlxxYBBH0esncoFmH8e+12/iOPLHFhN2tDc3iFkS7aq/F5kivwZFGcdYD0q7lFgcSDLj8Y8ls2s3dhfd2LzjmlFpkJynyyJkesM7rD2cS2QyPyaxih8TRaeJKB6eY5MOgjgMZuaJLQT3Ik3Xgc5CIBmQ4ojaCnf6GstMk56tlOTBOIVBOulcuphHIgTkDLb660MydHgYyCPscq5dVym/5PhRTTxWYtbIHg3FdKr45HuVGEZK2ZtEJuiL2JCgMt/WgrUxYVDVwGb7xfv7kTAo2ncLBCITaAQzpgr8GYbHSVV1uZq+rzrf26znvikPU3MDYmdggxSbSZXE7Yp8/MTTkN7bR1+4rdQtE/9pHEHXuYQi4SMPR9B3ySlfHmMYum4AnttOkcA6PBIvZ2/22OMzoREmqCghlWqZo4RCbl8bpmYCsoSDAgbb+DAzbvrS89CljzhRfOKnO06w7BGEB+BeARYwGcqwWyPWZvQZ0UeQ== nmiloserdov09@gmail.com";
          };
        };
      };
    };
}
