# Install packages with `nix-env -f default.nix -iA package-name`
{ system ? builtins.currentSystem }:

let
  nixpkgs = import <nixpkgs> { inherit system; };
  pkgs = import (nixpkgs.fetchFromGitHub (nixpkgs.lib.importJSON ./nixsrc.json)) {};
  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xlibs // self);

  self = {
  };

in self
