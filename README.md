nix run .#nixosConfigurations.$HOST-$HARDWARE-$ARCH.config.partitions-create
nix run .#nixosConfigurations.$HOST-$HARDWARE-$ARCH.config.partitions-mount




nixos-install --flake . #$HOST-$HARDWARE-$ARCH
