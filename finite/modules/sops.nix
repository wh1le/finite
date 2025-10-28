{
  pkgs,
  inputs,
  config,
  self,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.age.generateKey = true;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.defaultSopsFile = "${self}/secrets/default.yaml";
  sops.defaultSopsFormat = "yaml";

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
