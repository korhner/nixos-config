#!/usr/bin/env bash
set -e

# for example, workstation-dell-vostro-15-5510
HOST="$1"

mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

nixos-rebuild build --flake .#"${HOST}"

#bash ~/result/sw/bin/disko-create
#bash ~/result/sw/bin/disko-mount

#nixos-install --flake .#"${HOST}" --no-root-passwd