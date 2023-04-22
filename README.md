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
sudo systemctl start wpa_supplicant
wpa_cli
add_network
set_network 0 ssid <wifi_network>
set_network 0 psk <wifi_password>
set_network 0 key_mgmt WPA-PSK
enable_network 0

sudo su
nix-env -f '<nixpkgs>' -iA git
git clone https://github.com/korhner/nixos-config.git
bash setup-system-iso.sh <HOST>
```

```shell
cd /persist/home/<USER>/repositories
git clone https://github.com/korhner/nixos-config.git
```

## Maintaining the system

### Updating
TODO flake update
```
sudo nixos-rebuild switch --flake .
home-manager switch --flake .
```

### Impermanence
`impermanence-diff`

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