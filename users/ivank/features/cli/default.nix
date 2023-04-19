{ pkgs, ... }: {
  imports = [
    ./bash.nix
    ./direnv.nix
  ];
}