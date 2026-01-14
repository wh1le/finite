# Installing Nix

## NixOS ISO / Virtual Machine

Don't want to install Nix on your system? Boot a [NixOS ISO](https://nixos.org/download/) or run it in a virtual machine—Nix and flakes work out of the box.

## Linux / macOS

```bash
curl -L https://nixos.org/nix/install | sh
```

After installation, restart your terminal or run:

```bash
. ~/.nix-profile/etc/profile.d/nix.sh
```

## Windows (WSL2)

1. Install WSL2:

```powershell
wsl --install
```

2. Open Ubuntu/Debian from Start menu, then install Nix:

```bash
curl -L https://nixos.org/nix/install | sh
```

## Enable Flakes

Add to `~/.config/nix/nix.conf`:

```
experimental-features = nix-command flakes
```

Or run commands with:

```bash
nix --experimental-features 'nix-command flakes' <command>
```

## Verify

```bash
nix --version
```
