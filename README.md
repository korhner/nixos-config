curl -L -O https://github.com/korhner/nixos-config/archive/refs/heads/main.zip
unzip main.zip

nix run .#nixosConfigurations.workstation.config.partitions-create --extra-experimental-features nix-command --extra-experimental-features flakes
nix run .#nixosConfigurations.workstation.config.partitions-mount --extra-experimental-features nix-command --extra-experimental-features flakes

nixos-install --flake . #nixosConfigurations

nixos-rebuild --flake . To build system configurations
home-manager --flake . To build user configurations
nix build (or shell or run) To build and use packages

nix run github:nix-community/disko --extra-experimental-features nix-command --extra-experimental-features flakes -- -m zap_create_mount ./hosts/workstation-dell-vostro-15-5510/disko.nix
