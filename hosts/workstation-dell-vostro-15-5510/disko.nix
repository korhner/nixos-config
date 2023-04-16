{ ... }: {

disko.devices = {
  disk = {
    sda = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "ESP";
            start = "1MiB";
            end = "550MiB";
            fs-type = "fat32";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "luks";
            start = "550MiB";
            end = "-4G";
            content = {
              type = "luks";
              name = "crypted";
              content = {
                type = "btrfs";
                mountOptions = [ "compress=zstd" "noatime" ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    postCreateHook = "btrfs subvolume snapshot -r /mnt /mnt/root-blank";
                  };
                  "/nix" = {};
                  "/home" = {
                    postCreateHook = "btrfs subvolume snapshot -r /mnt/home /mnt/home-blank";
                  };
                  "/persist" = {};
                };
              };
            };
          }
          {
            name = "swap";
            start = "-4G";
            end = "100%";
            part-type = "primary";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          }
        ];
      };
    };
  };
  };

  fileSystems."/persist".neededForBoot = true;
}
