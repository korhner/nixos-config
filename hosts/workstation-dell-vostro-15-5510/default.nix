# System configuration for my laptop
{ pkgs, inputs, ... }: {
  imports = [
     # TODO check this: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
#    inputs.hardware.nixosModules.common-cpu-intel
#    inputs.hardware.nixosModules.common-gpu-intel
#    inputs.hardware.nixosModules.common-pc-ssd
#     ./disks.nix
    ./hardware-configuration.nix

    ../common/global
#    ../../users/ivank
    ./disko.nix
    disko.nixosModules.disko
  ];

  networking = {
    hostName = "workstation-dell-vostro-15-5510";
  };

  # TODO what is this
#  boot = {
#    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
#  };

#  powerManagement.powertop.enable = true;
#  programs = {
#    light.enable = true;
#    adb.enable = true;
#    dconf.enable = true;
#    kdeconnect.enable = true;
#  };

  # Lid settings
#  services.logind = {
#    lidSwitch = "suspend";
#    lidSwitchExternalPower = "lock";
#  };

#  xdg.portal = {
#    enable = true;
#    wlr.enable = true;
#  };
#  hardware = {
#    opengl = {
#      enable = true;
#      extraPackages = with pkgs; [ amdvlk ];
#      driSupport = true;
#      driSupport32Bit = true;
#    };
#  };

  system.stateVersion = "22.11";
}