## Various

curl -L -O https://github.com/korhner/nixos-config/archive/refs/heads/main.zip
unzip main.zip

nix run .#nixosConfigurations.workstation.config.partitions-create --extra-experimental-features nix-command --extra-experimental-features flakes
nix run .#nixosConfigurations.workstation.config.partitions-mount --extra-experimental-features nix-command --extra-experimental-features flakes

nixos-install --flake . #nixosConfigurations

nixos-rebuild --flake . To build system configurations
home-manager --flake . To build user configurations
nix build (or shell or run) To build and use packages


## Adding new machine

- Create new folder under in `hosts` dir
- Modify disko.nix
  - Change disk name. Find disk by running `lsblk -p`. For dell vostro, it's `/dev/sda`
  - Adjust swap partition size
    - Check this for reference https://itsfoss.com/swap-size/
    - Value needs to be set both on luks (end) and swap (start) partitions

## Installing nixos

- Download nixos iso minimal image and boot to it (TODO more instructions)
- Prepare environment:
```shell
sudo su
nix-shell -p git
git clone https://github.com/korhner/nixos-config.git
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
```
- Run disko to format disk (change host) `nix run github:nix-community/disko -- -m zap_create_mount ./hosts/workstation-dell-vostro-15-5510/disko.nix`
- Run `nixos-generate-config --root /mnt` and update hardware-configuration.nix if needed.
- Run `nixos-install --flake .#nixosConfigurations.workstation` (ovo ne radi jos)