{
  description = "NixOS configuration flake";

 inputs = {
     nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

  outputs = { self, nixpkgs, home-manager, disko }: {
    nix.registry.nixpkgs.flake = nixpkgs;
    nixosConfigurations.work-dell = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/work-dell
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
      ];
    };
  };
}