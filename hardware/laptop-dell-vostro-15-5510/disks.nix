{ config, lib, inputs, pkgs, modulesPath, isIso, ... }:
let
  DISK_NAME = "/dev/sda";  # TODO check this with `lsblk -p`
  SWAP_PARTITION_SIZE_MB = "1024";  # TODO check https://itsfoss.com/swap-size/

  BOOT_PARTITION_NAME = "ESP";
  SWAP_PARTITION_NAME = "swap";
  CRYPTED_PARTITION_NAME = "cryptsystem";
  DECRYPTED_PARTITION_NAME = "system";

  partitionsCreateScript = ''
    wipefs -af "$DISK_NAME"
    sgdisk -Zo "$DISK_NAME"
    sgdisk --clear \
           --new=1:0:+550Mib                       --typecode=1:ef00 --change-name=1:"$BOOT_PARTITION_NAME" \
           --new=2:0:+"$SWAP_PARTITION_SIZE_MB"Mib --typecode=2:8200 --change-name=2:"$SWAP_PARTITION_NAME" \
           --new=3:0:0                             --typecode=3:8309 --change-name=3:"$CRYPTED_PARTITION_NAME" \
             "$DISK_NAME"

    wait_seconds=10
    until test $((wait_seconds--)) -eq 0 -o -e /dev/disk/by-partlabel/"$BOOT_PARTITION_NAME" ; do sleep 1; done

    mkfs.fat -F32 -n $BOOT_PARTITION_NAME /dev/disk/by-partlabel/$BOOT_PARTITION_NAME

    mkswap /dev/disk/by-partlabel/$SWAP_PARTITION_NAME
    swapon /dev/disk/by-partlabel/$SWAP_PARTITION_NAME

    cryptsetup luksFormat /dev/disk/by-partlabel/$CRYPTED_PARTITION_NAME -d
    cryptsetup open /dev/disk/by-partlabel/$CRYPTED_PARTITION_NAME $DECRYPTED_PARTITION_NAME -d

    mkfs.btrfs --label "$DECRYPTED_PARTITION_NAME" /dev/mapper/"$DECRYPTED_PARTITION_NAME"
    mount -t btrfs LABEL="$DECRYPTED_PARTITION_NAME" /mnt

    btrfs subvolume create /mnt/root
    btrfs subvolume create /mnt/home
    btrfs subvolume create /mnt/nix
    btrfs subvolume create /mnt/persist

    btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
    umount /mnt
    cryptsetup close $DECRYPTED_PARTITION_NAME
  '';

  partitionsMountScript = ''
    cryptsetup open /dev/disk/by-partlabel/$CRYPTED_PARTITION_NAME $DECRYPTED_PARTITION_NAME -d
    mount -o subvol=root,compress=zstd,noatime,X-mount.mkdir LABEL="$DECRYPTED_PARTITION_NAME" /mnt
    mount -o subvol=home,compress=zstd,noatime,X-mount.mkdir LABEL="$DECRYPTED_PARTITION_NAME" /mnt/home
    mount -o subvol=nix,compress=zstd,noatime,X-mount.mkdir LABEL="$DECRYPTED_PARTITION_NAME" /mnt/nix
    mount -o subvol=persist,compress=zstd,noatime,X-mount.mkdir LABEL="$DECRYPTED_PARTITION_NAME" /mnt/persist
    mount -o defaults,X-mount.mkdir LABEL="$BOOT_PARTITION_NAME" /mnt/boot
  '';

  # Utility to save a snapshot of the root tree
  save-root = pkgs.writers.writeDashBin "save-root" ''
    ${pkgs.findutils}/bin/find \
      / -xdev \( -path /tmp -o -path /var/tmp -o -path /var/log/journal \) \
      -prune -false -o -print0 | sort -z | tr '\0' '\n' > "$1"
  '';

  # Utility to compare the root tree
  diff-root = pkgs.writers.writeDashBin "diff-root" ''
    export PATH=${with pkgs; lib.makeBinPath [ diffutils less ]}:$PATH
    current="$(mktemp current-root.XXX --tmpdir)"
    trap 'rm "$current"' EXIT INT HUP
    ${save-root}/bin/save-root "$current"
    diff -u /run/initial-root "$current" --color=always | ''${PAGER:-less -R}
  '';
in
{
  config = {

    # TODO
    environment.persistence."/persist" = {
      directories = [

      ];
      files = [

      ];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/$BOOT_PARTITION_NAME";
      fsType = "vfat";
    };

    boot.initrd.luks.devices."$DECRYPTED_PARTITION_NAME".device = "/dev/disk/by-partlabel/$CRYPTED_PARTITION_NAME";

    fileSystems."/home" = {
      device = "/dev/disk/by-partlabel/$DECRYPTED_PARTITION_NAME";
      fsType = "btrfs";
      options = [ "subvol=home" "compress-force=zstd" "noatime" ];
    };

    fileSystems."/nix" = {
      device = "/dev/disk/by-partlabel/$DECRYPTED_PARTITION_NAME";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress-force=zstd" "noatime" ];
    };

    fileSystems."/persist" = {
      device = "/dev/disk/by-partlabel/$DECRYPTED_PARTITION_NAME";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress-force=zstd" "noatime" ];
    };

    swapDevices = [
      { device = "/dev/disk/by-partlabel/swap"; }
    ];

    environment.systemPackages = [
      config.partitions-create
      config.partitions-mount

      diff-root
    ];

    systemd.services.save-root-snapshot = {
      description = "save a snapshot of the initial root tree";
      wantedBy = [ "sysinit.target" ];
      requires = [ "-.mount" ];
      after = [ "-.mount" ];
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
      serviceConfig.ExecStart = ''${save-root}/bin/save-root /run/initial-root'';
    };
  };

  options.partitions-create = with lib; mkOption rec {
    type = types.package;
    default = with pkgs; symlinkJoin {
      name = "partitions-create";
      paths = [ (writeScriptBin default.name partitionsCreateScript) wipefs sgdisk cryptsetup btrfs-progs ];
    };
  };

  options.disks-mount = with lib; mkOption rec {
    type = types.package;
    default = with pkgs; symlinkJoin {
      name = "partitions-mount";
      paths = [ (writeScriptBin default.name partitionsMountScript) cryptsetup ];
    };
  };

}