# Install packages with `nix-env -f default.nix -iA package-name`
{ system ? builtins.currentSystem }:

let
  nixpkgs = import <nixpkgs> { inherit system; };
  pinPkgs = import (nixpkgs.fetchFromGitHub (nixpkgs.lib.importJSON ../../nixsrc.json)) {};

  pkgs = pinPkgs // { 
    stdenv = pinPkgs.stdenv.overrideDerivation (attrs: attrs // {
      lib = attrs.lib // {
        maintainers = import ../../lib/maintainers.nix {} ; 
      };
    }); 
  };

  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xlibs // self);

  self = pkgs // {
  };

in self
