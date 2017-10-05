{ system ? builtins.currentSystem, pkg ? null }:
let
  nixpkgs = import <nixpkgs> { inherit system; };
  makeOverridable = nixpkgs.stdenv.lib.makeOverridable;
  pkgs = import ./pkgs/top-level/all-packages.nix;
in
  makeOverridable pkgs { pkg = pkg; shellDir = ./shell.nix; }
