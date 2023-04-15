# This file (and the global directory) holds config that i use on all hosts
{ lib, inputs, outputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager
    ./docker.nix
    ./locale.nix
    ./nix.nix
  ];

   environment.systemPackages = with pkgs; [
      #(uutils-coreutils.override { prefix = ""; })
      lm_sensors
      pulseaudio # used for tools
      alsa-utils
      python3
   ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  environment.persistence."/persist" = {
    directories = [
#      "/var/lib/systemd"
#      "/var/log"
    ];
    files = [];
  };

  hardware.enableRedistributableFirmware = true;
}