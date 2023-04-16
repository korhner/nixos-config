# https://grahamc.com/blog/erase-your-darlings/
# https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html

{ pkgs, lib, config, ... }:
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

    #btrfs subvolume snapshot -r /mnt      /mnt/root-blank
    #btrfs subvolume snapshot -r /mnt/home /mnt/home-blank

    nixos-install --flake .#"${hostname}" --no-root-passwd
  '';

  impermanenceDiff = pkgs.writeShellScriptBin "impermanence-diff" ''
    btrfs subvolume snapshot -r / /tmp/root-current
    btrfs send -p /root-blank /tmp/root-current --no-data | btrfs receive --dump
    btrfs subvolume snapshot delete /tmp/root-current

    btrfs subvolume snapshot -r /home /tmp/root-home
    btrfs send -p /home-blank /tmp/home-current --no-data | btrfs receive --dump
    btrfs subvolume snapshot delete /tmp/home-current
  '';



in {

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