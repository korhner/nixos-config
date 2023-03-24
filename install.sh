#!/usr/bin/env bash

set -e

BOOT_PARTITION_NAME=ESP
SWAP_PARTITION_NAME=swap
CRYPTED_PARTITION_NAME=cryptsystem
DECRYPTED_PARTITION_NAME=system

echo "#################################################################################################################"
echo "Collect user input"
echo "#################################################################################################################"

echo ""
echo "Output of 'lsblk -p':"
lsblk -p
echo "Check output of lsblk above to help you select disk to partition."
echo "For example /dev/sda or /dev/nvme0n1"
echo "Selected disk will be wiped and formatted!"
echo ""
echo -e "\e[1m\e[36mEnter full disk name:\e[0m"
read disk_name

echo ""
echo "Output of 'free -h':"
free -h
cat << EOF
Recommendations based on https://itsfoss.com/swap-size/
RAM Size	Swap Size
4Gib	      2Gib (enter 2048)
6Gib	      2Gib (enter 2048)
8Gib	      3Gib (enter 3072)
12Gib	      3Gib (enter 3072)
16Gib	      4Gib (enter 4096)
24Gib	      5Gib (enter 5120)
32Gib	      6Gib (enter 6144)
64Gib	      8Gib (enter 8192)
128Gib	    11Gib (enter 11264)
EOF
echo ""
echo -e "\e[1m\e[36mEnter size of swapfile in megabytes:\e[0m"
read swap_partition_size_mb

echo ""
echo -e "\e[1m\e[36mEnter password for disk encryption (you will not see it):\e[0m"
read -s disk_password

echo "#################################################################################################################"
echo "Wiping and partitioning disk"
echo "#################################################################################################################"
wipefs -af "$disk_name"
sgdisk -Zo "$disk_name"
sgdisk --clear \
       --new=1:0:+550Mib                       --typecode=1:ef00 --change-name=1:"$BOOT_PARTITION_NAME" \
       --new=2:0:+"$swap_partition_size_mb"Mib --typecode=3:8200 --change-name=3:"$SWAP_PARTITION_NAME" \
       --new=3:0:0                             --typecode=1:8309 --change-name=2:"$CRYPTED_PARTITION_NAME" \
         "$disk_name"

wait_seconds=10
until test $((wait_seconds--)) -eq 0 -o -e /dev/disk/by-partlabel/"$BOOT_PARTITION_NAME" ; do sleep 1; done

echo "#################################################################################################################"
echo "Formatting partitions"
echo "#################################################################################################################"
mkfs.fat -F32 -n $BOOT_PARTITION_NAME /dev/disk/by-partlabel/$BOOT_PARTITION_NAME

mkswap /dev/disk/by-partlabel/$SWAP_PARTITION_NAME
swapon /dev/disk/by-partlabel/$SWAP_PARTITION_NAME

echo -n "$disk_password" | cryptsetup luksFormat /dev/disk/by-partlabel/$CRYPTED_PARTITION_NAME -d -
echo -n "$disk_password" | cryptsetup open /dev/disk/by-partlabel/$CRYPTED_PARTITION_NAME $DECRYPTED_PARTITION_NAME -d -

mkfs.btrfs --label "$DECRYPTED_PARTITION_NAME" /dev/mapper/"$DECRYPTED_PARTITION_NAME"
mount -t btrfs LABEL="$DECRYPTED_PARTITION_NAME" /mnt

btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist

btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
umount /mnt

mount -o subvol=root,compress=zstd,noatime,X-mount.mkdir LABEL="$DECRYPTED_PARTITION_NAME" /mnt
mount -o subvol=home,compress=zstd,noatime,X-mount.mkdir LABEL="$DECRYPTED_PARTITION_NAME" /mnt/home
mount -o subvol=nix,compress=zstd,noatime,X-mount.mkdir LABEL="$DECRYPTED_PARTITION_NAME" /mnt/nix
mount -o subvol=persist,compress=zstd,noatime,X-mount.mkdir LABEL="$DECRYPTED_PARTITION_NAME" /mnt/persist

mount -o defaults,X-mount.mkdir LABEL="$BOOT_PARTITION_NAME" /mnt/boot

echo "#################################################################################################################"
echo "Setup base system"
echo "#################################################################################################################"
nixos-generate-config --root /mnt

# TODO issues:
# - swapDevices not populated in hardware configuration
# - btrfs options not populated in hardware configuration (noatime, compression)