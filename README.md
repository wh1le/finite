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

### Boot Pi and connect

```

ssh -p 1234 astronaut@192.168.1.253
```

Change the very-trustworthy default password "hackme":

```
passwd
```

Pi-hole needs to download its blocklist once. It cannot resolve DNS yet because it is the DNS. Classic chicken-and-egg. We cheat. Point it at Cloudflare just long enough to fetch the list, then switch back to the privacy bunker.

```
sudo podman exec -it pi-hole sh -lc 'printf "nameserver 1.1.1.1\nnameserver 1.0.0.1\n" >/etc/resolv.conf && pihole -g && printf "nameserver 127.0.0.1\nnameserver ::1\noptions edns0 trust-ad\n" >/etc/resolv.conf'
```

Set your Pi-hole Web UI password before someone else does:

```
sudo podman exec -it pi-hole pihole setpassword your_new_password
```

Open the Pi-hole dashboard from your PC on 192.168.1.253. Enjoy ads disappearing like your faith in online privacy.

## Notes

Tested on Raspberry Pi 3 B+. Reports for other models welcome.

## Work in progress

- [ ] Logo
- [ ] Automated SD Flashing script
- [ ] Backups for stats
- [ ] Add router documentation

## License

MIT © 2025 Nikita Miloserdov
See [LICENSE](./LICENSE)
