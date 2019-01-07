{ system ? builtins.currentSystem }:
let
  # nixpkgs = import <nixpkgs> { inherit system; };
  # makeOverridable = nixpkgs.stdenv.lib.makeOverridable;
  pkgs = import ./pkgs/top-level/all-packages.nix { inherit system; };
in
  # makeOverridable pkgs { inherit system; inherit timestamp; pkg = pkg; shellDir = ./shell.nix; }
  pkgs
