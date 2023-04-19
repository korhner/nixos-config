# System configuration for my laptop
{ pkgs, inputs, ... }: {
  imports = [
     # TODO check this: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
#    inputs.hardware.nixosModules.common-cpu-intel
#    inputs.hardware.nixosModules.common-gpu-intel
#    inputs.hardware.nixosModules.common-pc-ssd
#    Experiment with those (follow syntax above, this is just copy paste from flake.nix(
#      common-gpu-intel = import ./common/gpu/intel;
#      common-gpu-intel-disable = import ./common/gpu/intel/disable.nix;
#      common-gpu-nvidia = import ./common/gpu/nvidia/prime.nix;
#      common-gpu-nvidia-nonprime = import ./common/gpu/nvidia;
#      common-gpu-nvidia-disable = import ./common/gpu/nvidia/disable.nix;
#      common-hidpi = import ./common/hidpi.nix;
    ./hardware-configuration.nix
    ../common/global
    ../common/optional/emphemeral-btrfs.nix
    ../common/optional/xfce.nix
  ];

  programs.fish.enable = true;
  users.users = {
    ivank = {
      initialPassword = "qwe123";
      isNormalUser = true;
      extraGroups = [ "wheel" ];

      shell = pkgs.fish;
    };
  };

  programs.fuse.userAllowOther = true;

  systemd.tmpfiles.rules = [
      "d /home/ivank 0700 ivank -"
      "d /persist/home/ivank 0700 ivank -"
  ];

  networking.hostName = "work-dell";
  system.stateVersion = "22.11";
}