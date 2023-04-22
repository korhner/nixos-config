# System configuration for my laptop
{ inputs, pkgs, ... }: {
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
    ../common/optional/xfce.nix
  ];

  systemd.tmpfiles.rules = [
      "d /home/ivank 0700 ivank -"
      "d /persist/home/ivank 0700 ivank -"
  ];

  networking.hostName = "work-dell";
  system.stateVersion = "22.11";
}