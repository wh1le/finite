{
  description = "Finite. Privacy-focused DNS on Raspberry Pi using NixOS, Unbound, and Pi-hole";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
		let
      settings = import (./. + "/settings.nix") {};
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
    };
}
