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
cd nixos-config/script
bash format.sh (edit host inside script)
cd ..
nixos-install --flake .#workstation-dell-vostro-15-5510 --no-root-passwd` (change host)
```

Remove boot medium, reboot, run this in system
```shell
passwd (change user password)
git clone https://github.com/korhner/nixos-config.git
cd nixos-config
sudo nixos-rebuild switch --flake .#
nix build .#homeConfigurations.ivank@workstation-dell-vostro-15-5510.activationPackage
./result/activate
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
sudo su
nix-env -f '<nixpkgs>' -iA git
git clone https://github.com/korhner/nixos-config.git
cd nixos-config/script
bash mount.sh (edit host inside script)