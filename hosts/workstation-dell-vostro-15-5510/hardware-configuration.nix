{ inputs, ... }: {
  imports = [
    ./disko.nix
    inputs.disko.nixosModules.disko
#    ../common/optional/emphemeral-btrfs.nix
  ];

  boot = {
    kernelParams = [ "boot.shell_on_fail" ];
    initrd = {
      availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
    };
    loader = {
      systemd-boot.enable = true;
      grub = {
        enable = true;
        version = 2;
        efiSupport = true;
        enableCryptodisk = true;
        device = "nodev";
       };
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}