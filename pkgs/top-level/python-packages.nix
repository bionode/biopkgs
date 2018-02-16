{ system ? builtins.currentSystem, pkg ? null, shellDir ? ../../shell.nix, hiPrio ? null, nodejs-6_x ? null, timestamp ? "1970-01-01T00:00:01Z" }:

let
  nixpkgs = import <nixpkgs> { inherit system; };
  source = (nixpkgs.lib.importJSON ../../nixsrc.json);
  # pinPkgs = import (nixpkgs.fetchFromGitHub source.origin) { inherit system; };
  # To avoid compiling all from source (speed up) but loose some reproducibility, use the line below instead
  pinPkgs = import (fetchTarball https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz) { inherit system; };
  pkgs = pinPkgs // {
    stdenv = pinPkgs.stdenv.overrideDerivation (attrs: attrs // {
      lib = attrs.lib // {
        maintainers = import ../../lib/maintainers.nix {};
      };
    });
  };

  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xlibs // self);

  customPkgs = {
    mjc = callPackage ../development/python-modules/mjc {};
  };

  self = pkgs.python36Packages // customPkgs;

in self
