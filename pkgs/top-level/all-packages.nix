# Install packages with `nix-env -f default.nix -iA package-name`
{ system ? builtins.currentSystem, pkg ? null }:

let
  nixpkgs = import <nixpkgs> { inherit system; };
  source = (nixpkgs.lib.importJSON ../../nixsrc.json);
  pinPkgs = import (nixpkgs.fetchFromGitHub source.origin) {};

  pkgs = pinPkgs // { 
    stdenv = pinPkgs.stdenv.overrideDerivation (attrs: attrs // {
      lib = attrs.lib // {
        maintainers = import ../../lib/maintainers.nix {} ; 
      };
    }); 
  };

  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xlibs // self);

  customPkgs = {
    shell = (import ../../shell.nix).env;
    fastqc = callPackage ../applications/science/biology/fastqc {};
    kmc = callPackage ../applications/science/biology/kmc {};
    psmc = callPackage ../applications/science/biology/psmc {};
    trimmomatic = callPackage ../applications/science/biology/trimmomatic {};
  };

  allPkgs = pkgs // customPkgs;

  utils = {
    source = source;
    dockerTar = callPackage ./dockerTar.nix { pkg=allPkgs."${pkg}"; };
  };

  self = allPkgs // utils;

in self
