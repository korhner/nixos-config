{ inputs, ... }: {
  imports = [
    ./disko.nix
    inputs.disko.nixosModules.disko
#    ../common/optional/emphemeral-btrfs.nix
  ];

  boot = {
    kernelParams = [ "boot.shell_on_fail" ];
    initrd = {
      availableKernelModules = [ "ata_piix" "ahci" "sr_mod" "mptspi" ];
      kernelModules = [ ];
    };
    loader = {
#      systemd-boot.enable = true;
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