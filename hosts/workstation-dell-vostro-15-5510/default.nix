# System configuration for my laptop
{ pkgs, inputs, ... }: {
  imports = [
     # TODO check this: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
#    inputs.hardware.nixosModules.common-cpu-intel
#    inputs.hardware.nixosModules.common-gpu-intel
#    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
  ];
  users.users = {
    ivank = {
      initialPassword = "qwe123";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = [
        pkgs.home-manager
        pkgs.git
      ];
    };
  };

  networking.hostName = "workstation-dell-vostro-15-5510";
  system.stateVersion = "22.11";
}