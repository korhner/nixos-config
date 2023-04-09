curl -L -O https://github.com/korhner/nixos-config/archive/refs/heads/main.zip
unzip main.zip

nix run .#nixosConfigurations.$HOST-$HARDWARE-$ARCH.config.partitions-create --extra-experimental-features nix-command --extra-experimental-features flakes
nix run .#nixosConfigurations.$HOST-$HARDWARE-$ARCH.config.partitions-mount --extra-experimental-features nix-command --extra-experimental-features flakes




nixos-install --flake . #$HOST-$HARDWARE-$ARCH

