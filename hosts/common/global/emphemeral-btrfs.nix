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
    mkdir /tmp -p
    MNTPOINT=$(mktemp -d)
    (
      mount -t btrfs -o subvol=/ /dev/mapper/crypted "$MNTPOINT"
      trap 'umount "$MNTPOINT"' EXIT

      btrfs subvolume snapshot -r /$MNTPOINT/root /$MNTPOINT/root-current
      btrfs send -p /$MNTPOINT/root-blank /$MNTPOINT/root-current --no-data | btrfs receive --dump
      btrfs subvolume snapshot delete /$MNTPOINT/root-current

      btrfs subvolume snapshot -r /$MNTPOINT/home /$MNTPOINT/home-current
      btrfs send -p /$MNTPOINT/home-blank /$MNTPOINT/home-current --no-data | btrfs receive --dump
      btrfs subvolume snapshot delete /$MNTPOINT/home-current
    )
  '';

in {

  imports = [
#    inputs.impermanence.nixosModules.impermanence
  ];

  fileSystems."/persist".neededForBoot = true;

#  environment.persistence."/persist" = {
#    directories = [
#      "/var/lib/systemd"
#      "/var/log"
#    ];
#    files = [
#      "/etc/machine-id"
#    ];
#  };

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