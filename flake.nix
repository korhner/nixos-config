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

  outputs = { self, nixpkgs, home-manager, disko, impermanence, ... }@inputs:
   let
     inherit (self) outputs;
   in
   {
    nix.registry.nixpkgs.flake = nixpkgs;
    nixosConfigurations.work-dell = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs outputs; };
      modules = [
        ./hosts/work-dell
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ivank = import ./users/ivank/work.nix;
          home-manager.extraSpecialArgs = { inherit inputs outputs; };
        }
      ];
    };
  };
}