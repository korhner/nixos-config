#!/usr/bin/env bash
set -e

# Check if HOST parameter is present
if [ -z "$1" ]
then
  echo "Host parameter not passed"
  exit 1
fi

if [ "$(hostname)" != "nixos" ]
then
  echo "Must be run on live image"
  exit 1
fi

# for example, workstation-dell-vostro-15-5510
HOST="$1"

mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

nixos-rebuild build --flake .#"${HOST}"

# TODO check if those are in path in new system
./result/sw/bin/disko-create
./result/sw/bin/disko-mount

#btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

#nixos-install --flake .#"${HOST}" --no-root-passwd