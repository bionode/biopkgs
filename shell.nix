# Run simply with `nix-shell` in current dir
{ system ? builtins.currentSystem }:

let
  nixpkgs = import <nixpkgs> { inherit system; };
  pkgs = import (nixpkgs.fetchFromGitHub (nixpkgs.lib.importJSON ./nixsrc.json)) {};
  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xlibs // self);

  self = {
  };

in pkgs.stdenv.mkDerivation {
  name = "pkgs";
  buildInputs = with pkgs; [
  ];
}
