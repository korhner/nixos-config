{ pkgs, ... }: {
  imports = [
    ./bash.nix
    ./direnv.nix
  ];
  home.packages = with pkgs; [
     # TODO check those
#    comma # Install and run programs by sticking a , before them
#    distrobox # Nice escape hatch, integrates docker images with my environment
#
#    bc # Calculator
#    bottom # System viewer
#    ncdu # TUI disk usage
#    exa # Better ls
#    ripgrep # Better grep
#    fd # Better find
#    httpie # Better curl
#    diffsitter # Better diff
#    jq # JSON pretty printer and manipulator
#    trekscii # Cute startrek cli printer
#
#    nil # Nix LSP
#    nixfmt # Nix formatter
#
#    ltex-ls # Spell checking LSP
  ];
}