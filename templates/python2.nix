{
  inputs = {
    nixpkgs.url = "nixpkgs-unstable";
  };
  outputs = { self, nixpkgs }:
  let
    python = pkgs.python310;
  in
  {
    defaultPackage.x86_64-linux = python.withPackages (ps: with ps; [
      pkgs.pip
    ]);
    devShell.x86_64-linux = python.mkShell {
      buildInputs = with pkgs; [
        pkgs.pip
      ];
    };
    shellHook = ''
      export PYTHONPATH="${PYTHONPATH:+$PYTHONPATH:}$PWD"
    '';
    packages = import ./requirements.txt { inherit pkgs; python = python; };
  };
}