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

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/systemd"
      "/var/log"
      "/srv"
    ];
    files = [];
  };

  hardware.enableRedistributableFirmware = true;
}