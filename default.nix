{ system ? builtins.currentSystem, pkg ? null, timestamp ? "1970-01-01T00:00:01Z" }:
let
  nixpkgs = import <nixpkgs> { inherit system; };
  makeOverridable = nixpkgs.stdenv.lib.makeOverridable;
  pkgs = import ./pkgs/top-level/all-packages.nix;
in
  makeOverridable pkgs { inherit system; inherit timestamp; pkg = pkg; shellDir = ./shell.nix; }
