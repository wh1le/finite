# Finite

Pi-hole and Unbound configuration for Raspberry PI using NixOS

## Building steps

First you need to setup Sops and generate keys. After change secrets
to match your configuration:

```bash
$ sops secrets/default.yaml
```

Update default settings at flake.nix:

- USERNAME - your user name
- STATIC_IP - desired IP for your Raspberry PI
- ROUTER_IP - your router IP you can run `ip r`

Build Image:

```
$ nix build .#nixosConfigurations.khole.config.system.build.sdImage
```

Write image to SD card:

```
# User lsblk -f to find your card or flashdrive path
$ sudo dd if=./result/sd-image/your_image_name.img of=/dev/your_drive bs=4M status=progress conv=fsync
```

## Notes

I tested this build on Raspberry PI 3 B+ and it works flawlessly. Let me know how it runs on thers version of PI.

## Work in progress

- [ ] Configure PI-hole filters
- [ ] Add logo

## License

MIT © 2025 Nikita Miloserdov — see [LICENSE](./LICENSE) for details.
