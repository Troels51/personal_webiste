{
  description = "A flake to generate my personal website";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.site = pkgs.stdenv.mkDerivation rec {
          name = "hffmr.dk";
          src = ./.;
          nativeBuildInputs = [ pkgs.zola ];
          buildPhase = "zola build";
          installPhase = "cp -r public $out";
        };
        defaultPackage = self.packages.${system}.site;
        devShell = pkgs.mkShell {
          packages = [ pkgs.zola ];
        };
      }
    );
}
