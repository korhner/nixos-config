{
  imports = [
    ../common/optional/btrfs-optin-persistence.nix
    ../common/optional/emphemeral-btrfs.nix
  ];

  boot = {
    initrd = {
      # TODO what is this
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
      kernelModules = [ "kvm-amd" ];
    };
    loader = {
      systemd-boot = {
        enable = true;
        # TODO what is this
        consoleMode = "max";
      };
      # TODO what is this
      efi.canTouchEfiVariables = true;
    };
  };

#  boot.initrd.luks.devices."$DECRYPTED_PARTITION_NAME".device = "/dev/disk/by-partlabel/$CRYPTED_PARTITION_NAME";
#
#
#  fileSystems = {
#    "/boot" = {
#      device = "/dev/disk/by-label/ESP";
#      fsType = "vfat";
#    };
#  };
#
#  swapDevices = [{
#    device = "/swap/swapfile";
#    size = 8196;
#  }];

  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
  # TODO what is this
#  powerManagement.cpuFreqGovernor = "powersave";
}