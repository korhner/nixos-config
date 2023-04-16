# https://grahamc.com/blog/erase-your-darlings/
# https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html

{ pkgs, lib, config, ... }: {
  boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    mkdir /tmp -p
    MNTPOINT=$(mktemp -d)
    (
      mount -t btrfs -o subvol=/ /dev/disk/by-label/${hostname} "$MNTPOINT"
      trap 'umount "$MNTPOINT"' EXIT
      echo "Cleaning root subvolume"
      btrfs subvolume list -o "$MNTPOINT/root" | cut -f9 -d ' ' |
      while read -r subvolume; do
        btrfs subvolume delete "$MNTPOINT/$subvolume"
      done && btrfs subvolume delete "$MNTPOINT/root"
      echo "Restoring blank subvolume"
      btrfs subvolume snapshot "$MNTPOINT/root-blank" "$MNTPOINT/root"
    )
  '';
}