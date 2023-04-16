## Adding new machine

- Create new folder under in `hosts` dir
- Modify hardware-configuration.nix
  - Change disk name. Find disk by running `lsblk -p`. For dell vostro, it's `/dev/sda`
  - Adjust swap partition size
    - Check this for reference https://itsfoss.com/swap-size/
    - Value needs to be set both on luks (end) and swap (start) partitions
- Modify default.nix
  - Change user, hostname, ...

## Installing nixos
- Download nixos iso minimal image and boot to it (TODO more instructions)

- Run this in ISO
```shell
sudo su
nix-env -f '<nixpkgs>' -iA git
git clone https://github.com/korhner/nixos-config.git
bash install.sh <HOST>
```

Remove boot medium, reboot, run this in system
```shell
passwd (change user password)
nix-shell -p home-manager git
mkdir repositories
cd repositories
git clone https://github.com/korhner/nixos-config.git
cd nixos-config
sudo nixos-rebuild switch --flake .
home-manager switch --flake .
CTRL + D to exit shell
reboot
```

## Maintaining the system

### Updating
```
sudo nixos-rebuild switch --flake .
home-manager switch --flake .
```

### Impermanence
```shell
sudo btrfs subvolume snapshot -r / /tmp/root-current
sudo btrfs subvolume list -t /
sudo btrfs send -p /root-blank /tmp/root-current --no-data | btrfs receive --dump
sudo btrfs subvolume snapshot delete /tmp/root-current

```

## Debugging the flake
```shell
nix repl
:lf .
outputs
```

## Testing on VM
- Create a linux 64bit VM (had problems with virtualbox, worked in vmware)
- Mount minimal iso install
- Find vmx file and make sure `firmware = "efi"` exists

## Boot to repair system
```shell
sudo su
nix-env -f '<nixpkgs>' -iA git
git clone https://github.com/korhner/nixos-config.git
cd nixos-config/script
bash mount.sh (edit host inside script)
```