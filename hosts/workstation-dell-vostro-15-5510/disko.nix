{ disks ? [ "/dev/sda" ], ... }: {
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = builtins.elemAt disks 0;
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
                name = "cryptsystem";
                content = {
                  type = "btrfs";
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" "noatime" ];
                  extraArgs = [ "--label system" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                    };
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
}
