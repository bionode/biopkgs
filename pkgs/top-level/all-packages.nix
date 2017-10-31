# Install packages with `nix-env -f default.nix -iA package-name`
{ system ? builtins.currentSystem, pkg ? null, shellDir ? ../../shell.nix, hiPrio ? null, nodejs-6_x ? null, timestamp ? "1970-01-01T00:00:01Z" }:

let
  nixpkgs = import <nixpkgs> { inherit system; };
  source = (nixpkgs.lib.importJSON ../../nixsrc.json);
  pinPkgs = import (nixpkgs.fetchFromGitHub source.origin) { inherit system; };

  pkgs = pinPkgs // {
    stdenv = pinPkgs.stdenv.overrideDerivation (attrs: attrs // {
      lib = attrs.lib // {
        maintainers = import ../../lib/maintainers.nix {};
      };
    });
  };

  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xlibs // self);

  customPkgs = {
    # aspera = callPackage ../tools/networking/aspera {};
    # bbcp = callPackage ../tools/networking/bbcp {};
    # fastqc = callPackage ../applications/science/biology/fastqc {};
    # kmc = callPackage ../applications/science/biology/kmc {};
    # ncbi-vdb = callPackage ../applications/science/biology/ncbi-vdb {};
    # nextflow = callPackage ../applications/science/misc/nextflow {};
    # ngs = callPackage ../applications/science/biology/ngs {};
    # seqlib = callPackage ../applications/science/biology/seqlib {};
    htslib = callPackage ../development/libraries/science/biology/htslib {};
    seqtk = callPackage ../applications/science/biology/seqtk {};
    # sra-tools = callPackage ../applications/science/biology/sra-tools {};
    psmc = callPackage ../applications/science/biology/psmc {};
    # trimmomatic = callPackage ../applications/science/biology/trimmomatic {};
    # tsunami-udp = callPackage ../tools/networking/tsunami-udp {};
    # udpcast = callPackage ../tools/networking/udpcast {};
    # udr = callPackage ../tools/networking/udr {};
    # nodejs = hiPrio nodejs-6_x;
    # nodePackages_6_x = callPackage ../development/node-packages/default-v6.nix {
      # nodejs = pkgs.nodejs-6_x;
    # };
  };

  customEnvs = {
    shell = (import shellDir).env;
  };

  allPkgs = pkgs // customPkgs // customEnvs;

  utils = {
    source = source;
    customPkgs = customPkgs;
    dockerTar = callPackage ./dockerTar.nix { inherit timestamp; pkg=allPkgs."${pkg}"; shellDir=(builtins.toPath shellDir); };
    nodePackages = customPkgs.nodePackages_6_x;
  };

  self = allPkgs // utils;

in self
