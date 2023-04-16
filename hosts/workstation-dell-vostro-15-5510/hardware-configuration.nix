{ inputs, ... }: {
  imports = [
    ./disko.nix
    inputs.disko.nixosModules.disko
#    ../common/optional/emphemeral-btrfs.nix
  ];

  environment.systemPackages = [
    (pkgs.writeScript "disko-create" (config.system.build.formatScript))
    (pkgs.writeScript "disko-mount" (config.system.build.mountScript))
  ];

  boot = {
    kernelParams = [ "boot.shell_on_fail" ];
    initrd = {
      availableKernelModules = [ "ata_piix" "ahci" "sr_mod" "mptspi" ];
      kernelModules = [ ];
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}