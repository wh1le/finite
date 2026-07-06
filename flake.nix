{
  description = "Finite. Privacy-focused DNS on Raspberry Pi using NixOS, Unbound, and Pi-hole";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      settings = import ./settings.nix;
    in
    {
      nixosConfigurations = {
        finite = nixpkgs.lib.nixosSystem {
          system = settings.SYSTEM;
          modules = [
            ./hosts/finite/default.nix
            home-manager.nixosModules.home-manager
          ];
          specialArgs = {
            inherit self inputs settings;
          };
        };
      };
    };
}
