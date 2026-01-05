{
  description = "Finite. Privacy-focused DNS on Raspberry Pi using NixOS, Unbound, and Pi-hole";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, deploy-rs, ... }@inputs:
    let
      settings = import ./settings.nix;
    in
    {
      nixConfig = {
        extra-experimental-features = [ "nix-command" "flakes" ];
      };

      nixosConfigurations = {
        finite = nixpkgs.lib.nixosSystem {
          system = settings.SYSTEM;
          modules = [
            ./finite/configuration.nix
            home-manager.nixosModules.home-manager
          ];
          specialArgs = {
            inherit self inputs settings;
          };
        };
      };

      deploy.nodes.finite = {
        hostname = settings.STATIC_IP;
        sshUser = settings.USERNAME;
        sshOpts = [ "-p" (toString settings.SSH_PORT) ];
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.finite;
        };
      };
    };
}
