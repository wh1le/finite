<h1 align="center">Finite</h1>

<p align="center">
  <img src="https://raw.githubusercontent.com/wh1le/finite/main/assets/logo2.png" width="400" />
</p>

<p align="center">
    <a href="https://nixos.org/">
        <img src="https://img.shields.io/badge/NixOS-25.05-informational.svg?style=for-the-badge&logo=nixos&color=F2CDCD&logoColor=D9E0EE&labelColor=302D41">
    </a>
    <a href="https://github.com/pi-hole/pi-hole">
        <img src="https://img.shields.io/badge/Pi--hole-6.2.1-informational.svg?style=for-the-badge&logo=pi-hole&color=F2CDCD&logoColor=D9E0EE&labelColor=302D41">
    </a>
    <a href="https://github.com/NLnetLabs/unbound">
        <img src="https://img.shields.io/badge/Unbound-1.23.1-informational.svg?style=for-the-badge&color=F2CDCD&logoColor=D9E0EE&labelColor=302D41">
    </a>
</p>

Finite is a NixOS configuration that ships Pi-hole + Unbound as a tiny fortress for your network. Drop it onto a Raspberry Pi and you get ad-blocking, DNS privacy, and self-hosting satisfaction with almost no effort.

_Why_

- **Your DNS stays local.**
  Normally, every website you visit triggers a DNS request that goes to a company’s server like Google’s or your ISP’s giving them a complete log of what you browse.
  With Finite, your Raspberry Pi handles those lookups locally. No external logging, no silent profiling.
  Whether you’re a small business or an individual who values privacy, you keep control of your own data.

- **Ads and trackers are blocked at the source**
  Pi-hole filters out ad and tracking domains before they even reach your browser, so all your devices benefit automatically.

- **It’s fully declarative.**
  All settings live in clean configuration files. Change one line, rebuild, and your setup updates instantly and predictably no manual tweaks to remember.

_What_

- **Clone, tweak, build, boot.**
  Grab the repo, set a few variables, build the SD image, and start your Pi. That’s all it takes to get a private DNS and ad blocker running.

- **Clean, organized configuration.**
  Passwords, network settings, and services are separated and easy to adjust. No fragile scripts or hidden system files.

- **Powered by Nix flakes.**
  Everything is versioned and reproducible. You can safely experiment, roll back changes, or extend the system without breaking it perfect for curious tinkerers.

## Setup

### Environment variables

Adjust defaults in ./flake.nix:

| variables           | Example Value                                                             | Description                                                                                 |
| ------------------- | ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| `STATE_VERSION`     | `"25.05"`                                                                 | NixOS release version to maintain compatibility with Nix modules.                           |
| `SYSTEM`            | `"aarch64-linux"`                                                         | Target architecture for the Raspberry Pi (ARMv8 64-bit).                                    |
| `USERNAME`          | `"astronaut"`                                                             | Default system user created during image build.                                             |
| `USER_PASSWORD`     | `"hackme"`                                                                | Default password for the system user (must be changed after first login).                   |
| `SSH_PORT`          | `1234`                                                                    | Port number for incoming SSH connections.                                                   |
| `SSH_PUBLIC_KEY`    | `"ssh-rsa AAAA..."`                                                       | Authorized SSH public key for passwordless login.                                           |
| `TIMEZONE`          | `"Europe/Lisbon"`                                                         | System timezone configuration.                                                              |
| `ROUTER_IP`         | `"192.168.50.1"`                                                          | IP address of the network’s router/gateway for DNS and routing configuration.               |
| `STATIC_IP`         | `"192.168.50.2"`                                                          | Fixed IP assigned to the Raspberry Pi host.                                                 |
| `TIMESYNCD_SERVERS` | `[ "162.159.200.1" "162.159.200.123" ]`                                   | NTP servers used for initial time synchronization to prevent Unbound TLS errors.            |
| `UNBOUND_SUBNETS`   | `[ "127.0.0.1/32 allow" "192.168.1.0/24 allow" "192.168.50.0/24 allow" ]` | CIDR blocks with access control rules for Unbound (which clients can query the DNS server). |
| `UNBOUND_PORT`      | `"5335"`                                                                  | Listening port for the Unbound DNS resolver.                                                |

### Build Image

```
make build_image
# or
nix build .#nixosConfigurations.finite.config.system.build.sdImage
```

### Flash SD card

1. **Find target disk:**

```
# linux
lsblk -f

# macOS
diskutil list
```

2. **Write image:**

```
# linux
sudo dd if=./result/sd-image/your_image_name.img of=/dev/your_disk_name bs=4M status=progress conv=fsync

# macOS
diskutil unmountDisk /dev/your_disk_name
sudo dd if=./result/sd-image/your_image_name.img of=/dev/your_disk_name bs=4M status=progress conv=fsync
```

### Boot Pi and connect

```
ssh -p 1234 astronaut@192.168.1.253
```

Change the very-trustworthy default password "hackme":

```
passwd
```

Set your Pi-hole Web UI password before someone else does:

```
sudo podman exec -it pi-hole pihole setpassword your_new_password
```

Open the Pi-hole dashboard from your PC at your configured IP address STATIC_IP/admin, for example:

```
http://192.168.50.2/admin
```

Enjoy watching ads vanish faster than your faith in online privacy.

### Router Configuration

So you’ve got your shiny little fortress running. Now make your router bow to it.

#### 1. Point your router’s DNS to Pi-hole

In your router admin panel, find **LAN → DNS Server** and set it to your Pi’s static IP:

```
 DNS 1 Server: 192.168.50.2
 DNS 2 Server: leave blank
```

That’s it. Your whole network now swears allegiance to Pi-hole.

#### 2. When your ISP router acts like a tyrant 👑

Some ISP routers think _you_ don’t deserve custom DNS. Fine. Outsmart them.

- **Option A: Let Pi-hole run DHCP**

  _must be noted that it is not tested and probably needs additional tweaking. I recommend option B if you don't know what you are doing. Future support for DHCP might be added later._

  - Turn off DHCP on your router.
  - In Pi-hole’s web UI → _Settings → DHCP_ → enable it.
  - Now Pi-hole hands out IPs and DNS like a benevolent dictator.

- **Option B: Use a real router**
  - Plug your own router into the ISP box.
  - Let _your_ router manage DHCP and DNS.
  - Keep the ISP router just to reach the internet.
  - Double NAT? Maybe. Freedom? Definitely.

#### 3. Check your work 🔍

Run this from any client:

```
nslookup github.com 192.168.50.2
```

If it answers, Pi-hole reigns supreme.  
Then open the Pi-hole dashboard → _Query Log_ → watch the ads die in real time.

### Blacklist management

For curated and well-maintained DNS blacklists, start here:
(hagezi/dns-blocklists)[https://github.com/hagezi/dns-blocklists]

## Notes

Tested on Raspberry Pi 3 B+. Reports for other models are welcome.
Expected to work on:

- Pi 2 v1.2 and later
- Pi 3
- Pi 4
- Pi 5 → ARMv8

For other versions, adjust the SYSTEM variable in ./settings.nix to match your architecture, and share your results if it works.

## Work in progress

- [ ] Automatic backups for pi-hole stats

## License

MIT © 2025 Nikita Miloserdov
See [LICENSE](./LICENSE)
