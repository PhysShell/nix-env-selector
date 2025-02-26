{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;

  nixPackages = [
    pkgs.nodejs-18_x
    pkgs.jdk11
    pkgs.yarn
    pkgs.vsce
  ];

  projectNodeModules = pkgs.mkYarnPackage {
    name = "nix-env-selector";
    src = ./.;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;
  };

in
pkgs.stdenv.mkDerivation {
  name = "nix-env-selector-dev";
  buildInputs = nixPackages ++ [ projectNodeModules ];

  shellHook = ''
    export PATH="${projectNodeModules}/bin:${projectNodeModules}/libexec/nix-env-selector/deps/nix-env-selector/node_modules/.bin:$PATH"
  '';
}
