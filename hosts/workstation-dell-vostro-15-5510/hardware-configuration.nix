{ inputs, ... }: {
  imports = [
    inputs.disko.nixosModules.disko
#    ../common/optional/emphemeral-btrfs.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
    };
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
  };

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
              name = "cryptsystem";
              start = "550MiB";
              end = "-4G";
              content = {
                type = "luks";
                name = "system";
                content = {
                  type = "btrfs";
                  mountOptions = [ "compress=zstd" "noatime" ];
                  extraArgs = [ "--label system" ];
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
  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}