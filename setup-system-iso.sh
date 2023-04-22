#!/usr/bin/env bash
set -e

if [ -z "$1" ]
then
  echo "Host not passed (work-dell, ...)"
  exit 1
fi

HOST="$1"

mount -o remount,size=10G /nix/.rw-store
mount -o remount,size=10G /nix/store

mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

nixos-rebuild build --flake .#"${HOST}"
./result/sw/bin/setup-system-iso

reboot
