{ pkgs, config, lib, outputs, ... }: {
  programs.fish.enable = true;
  users.users.ivank = {
    initialPassword = "qwe123";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    packages = [ pkgs.home-manager ];
  };

  programs.fuse.userAllowOther = true;

  home-manager.users.ivank = import "home/${config.networking.hostName}.nix";
}