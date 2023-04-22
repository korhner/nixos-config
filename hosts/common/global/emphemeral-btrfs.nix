# https://grahamc.com/blog/erase-your-darlings/
# https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html

{ pkgs, lib, config, inputs, ... }:
let
  hostname = config.networking.hostName;

  setupSystemIso = pkgs.writeShellScriptBin "setup-system-iso" ''
    if [ "$(hostname)" != "nixos" ]
    then
      echo "Must be run on live image"
      exit 1
    fi

    ${config.system.build.formatScript}
    ${config.system.build.mountScript}

    nixos-install --flake .#"${hostname}" --no-root-passwd
  '';

  impermanenceDiff = pkgs.writeShellScriptBin "impermanence-diff" ''
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p /mnt
    mount -t btrfs -o subvol=/ /dev/mapper/crypted "/mnt"
    trap 'umount /mnt' EXIT
    for SUBVOLUME in root home
    do
      OLD_TRANSID=$(btrfs subvolume find-new /mnt/$SUBVOLUME-blank 9999999)
      OLD_TRANSID="''${OLD_TRANSID#transid marker was }"
      btrfs subvolume find-new "/mnt/$SUBVOLUME" "$OLD_TRANSID" |
      sed '$d' |
      cut -f17- -d' ' |
      sort |
      uniq |
      while read path; do
        path="/$path"
        if [ -L "$path" ]; then
          : # The path is a symbolic link, so is probably handled by NixOS already
        elif [ -d "$path" ]; then
          : # The path is a directory, ignore
        else
          echo "$path"
        fi
      done
    done
  '';

in {

  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/systemd"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  environment.systemPackages = [ setupSystemIso impermanenceDiff ];

  boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    mkdir /tmp -p
    MNTPOINT=$(mktemp -d)
    (
      mount -t btrfs -o subvol=/ /dev/mapper/crypted "$MNTPOINT"
      trap 'umount "$MNTPOINT"' EXIT

      btrfs subvolume list -o "$MNTPOINT/root" | cut -f9 -d ' ' |
      while read -r subvolume; do
        btrfs subvolume delete "$MNTPOINT/$subvolume"
      done && btrfs subvolume delete "$MNTPOINT/root"
      btrfs subvolume snapshot "$MNTPOINT/root-blank" "$MNTPOINT/root"

      btrfs subvolume list -o "$MNTPOINT/home" | cut -f9 -d ' ' |
      while read -r subvolume; do
        btrfs subvolume delete "$MNTPOINT/$subvolume"
      done && btrfs subvolume delete "$MNTPOINT/home"
      btrfs subvolume snapshot "$MNTPOINT/home-blank" "$MNTPOINT/home"
    )
  '';
}