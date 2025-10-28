# Finite

Finite is a NixOS configuration that ships Pi-hole + Unbound as a tiny fortress for your network. Drop it onto a Raspberry Pi and you get ad-blocking, DNS privacy, and smug self-hosting satisfaction with almost no effort.

_Why_

- Your queries stay home. Zero blind trust in external DNS.
- Ads and trackers get 404’d at the gate.
- Everything is declarative. Change a line. Rebuild. Done.

_What_

- Clone repo. Set a few vars. Build SD image. Boot. Enjoy.
- Secrets and config neatly structured so tinkering stays painless.
- Built with flakes so you can mutate your setup like a responsible mad scientist.

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
