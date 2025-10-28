{
  description = "Finite. Privacy-focused DNS on Raspberry Pi using NixOS, Unbound, and Pi-hole";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, sops-nix, ... }@inputs:
    {
      nixConfig = {
        extra-experimental-features = [ "nix-command" "flakes" ];
      };

      nixosConfigurations = {
        finite = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./finite/configuration.nix
            inputs.sops-nix.nixosModules.sops
          ];
          specialArgs = {
            inherit self inputs;

            USERNAME = "austronaut";

            # System version switch if outdated
            STATE_VERSION = "25.05";

            # Your desired fixed raspberry IP
            STATIC_IP = "192.168.1.253";

            # Your router IP
            ROUTER_IP = "192.168.1.254";

            # It used by Pi-hole for DNS management
            UNBOUND_PORT = "5335";

            # https://developers.cloudflare.com/time-services/ntp/usage/#linux
            # On first boot unbound fails to start because of certificate problem related to system date
            # here we allow to connect to cloudflare to fetch current time and set system date so unbound can start
            TIMESYNCD_SERVERS = [ "162.159.200.1" "162.159.200.123" ];

            # Set ssh port
            SSH_PORT = 1234;
          };
        };
      };
    };
}
