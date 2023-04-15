#! /usr/bin/env bash

HOST="workstation-dell-vostro-15-5510"

mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

nix run github:nix-community/disko -- -m zap_create_mount ../hosts/$HOST/disko.nix

# Generate config so it can be inspected
nixos-generate-config --root /tmp