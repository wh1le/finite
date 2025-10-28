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

## Setup

### Environment variables

Install Sops and generate your keys. Then edit secrets:

```bash
sops secrets/default.yaml
```

User password needs to be in hash form user this:

```
mkpasswd -m sha-512 "your password"
# put output to secrets/default.yaml
```

Adjust defaults in flake.nix:

- USERNAME - your user name
- STATIC_IP - desired IP for your Raspberry PI
- ROUTER_IP - your router IP you can run `ip r`

### Build Image

```
nix build .#nixosConfigurations.finite.config.system.build.sdImage
```

### Flash SD card

```
lsblk -f   # find target disk
sudo dd if=result/sd-image/*.img of=/dev/sdX bs=4M status=progress conv=fsync
sync
```

Boot the Pi. Pi-hole web UI should now resolve your existential dread.

### Enable filtering

Open your router configuration and wire it with Raspberry

## Notes

Tested on Raspberry Pi 3 B+. Reports for other models welcome.

## Work in progress

- [ ] Pi-hole filter defaults
- [ ] Logo
- [ ] Automated SD Flashing script
- [ ] Backups for stats
- [ ] Add router documentation

## License

MIT © 2025 Nikita Miloserdov
See [LICENSE](./LICENSE)
