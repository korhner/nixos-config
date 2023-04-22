{ lib, inputs, outputs, ... }:
{
  imports = [
#    ./nix.nix
#    ./emphemeral-btrfs.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  hardware.enableRedistributableFirmware = true;

  virtualisation.docker = {
    enable = true;
  };

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    supportedLocales = lib.mkDefault [
      "en_US.UTF-8/UTF-8"
    ];
  };
  time.timeZone = lib.mkDefault "Europe/Belgrade";
}