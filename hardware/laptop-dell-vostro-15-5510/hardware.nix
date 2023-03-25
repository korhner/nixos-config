{ config, lib, inputs, pkgs, modulesPath, ... }:
let
  powerMode = "performance";
in
{
  imports = [
    ./disks.nix
  ];

}