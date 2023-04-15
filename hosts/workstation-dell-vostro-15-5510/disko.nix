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
            type = "partition";
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
            type = "partition";
            name = "luks";
            start = "550MiB";
            end = "-4G";
            content = {
              type = "luks";
              name = "crypted-root";
              content = {
                type = "btrfs";
                mountOptions = [ "compress=zstd" "noatime" ];
                subvolumes = {
                  "/root" = { mountpoint = "/"; };
                  "/nix" = {};
                  "/home" = {};
                  "/persist" = {};
                };
              };
            };
          }
          {
            name = "swap";
            type = "partition";
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
