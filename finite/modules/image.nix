{ modulesPath,  ... }:

{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];

  sdImage.compressImage = false;
}
