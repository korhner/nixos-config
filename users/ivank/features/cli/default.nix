{ pkgs, ... }: {
  imports = [
    ./bash.nix
    ./direnv.nix
    ./fish.nix
  ];
}