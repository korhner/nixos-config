{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, disko, home-manager, ... }: {
    nixosConfigurations = {
      "work-dell" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./hosts/work-dell
#          home-manager.nixosModules.home-manager
#          {
#            home-manager.useGlobalPkgs = true;
#            home-manager.useUserPackages = true;
#            home-manager.users.ivank = import ./users/ivank/workstation.nix;
#          }
        ];
      };
    };
  };
}