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
    # ncbi-vdb = callPackage ../applications/science/biology/ncbi-vdb {};
    # nextflow = callPackage ../applications/science/misc/nextflow {};
    # ngs = callPackage ../applications/science/biology/ngs {};
    # seqlib = callPackage ../applications/science/biology/seqlib {};
    # sra-tools = callPackage ../applications/science/biology/sra-tools {};
    # tsunami-udp = callPackage ../tools/networking/tsunami-udp {};
    # udpcast = callPackage ../tools/networking/udpcast {};
    # udr = callPackage ../tools/networking/udr {};
    # nodejs = hiPrio nodejs-6_x;
    # nodePackages_6_x = callPackage ../development/node-packages/default-v6.nix {
      # nodejs = pkgs.nodejs-6_x;
    # };
  };

  containerReadyPkgs = {
    bcftools = callPackage ../applications/science/biology/bcftools {};
    bedtools = callPackage ../applications/science/biology/bedtools {};
    bowtie2 = callPackage ../applications/science/biology/bowtie2 {};
    bwa = callPackage ../applications/science/biology/bwa {};
    fastqc = callPackage ../applications/science/biology/fastqc {};
    freebayes = callPackage ../applications/science/biology/freebayes {};
    kmc = callPackage ../applications/science/biology/kmc {};
    mrbayes = callPackage ../applications/science/biology/mrbayes {};
    paml- = callPackage ../applications/science/biology/paml {};
    picard-tools = callPackage ../applications/science/biology/picard-tools {};
    plink = callPackage ../applications/science/biology/plink {};
    plink-ng = callPackage ../applications/science/biology/plink-ng {};
    psmc = callPackage ../applications/science/biology/psmc {};
    seqbility = callPackage ../applications/science/biology/seqbility {};
    msmc = callPackage ../applications/science/biology/msmc {};
    msmc-bin = callPackage ../applications/science/biology/msmc-bin {};
    msmc2 = callPackage ../applications/science/biology/msmc2 {};
    msmc-tools = callPackage ../applications/science/biology/msmc-tools {};
    htslib = callPackage ../development/libraries/science/biology/htslib {};
    samtools = callPackage ../applications/science/biology/samtools {};
    seqtk = callPackage ../applications/science/biology/seqtk {};
    trimmomatic = callPackage ../applications/science/biology/trimmomatic {};
  };

  customEnvs = {
    shell = (import shellDir).env;
  };

  allPkgs = pkgs // customPkgs // containerReadyPkgs // customEnvs;

  utils = {
    source = source;
    containerReadyPkgs = containerReadyPkgs;
    dockerTar = callPackage ./dockerTar.nix { inherit timestamp; pkg=allPkgs."${pkg}"; shellDir=(builtins.toPath shellDir); };
    nodePackages = customPkgs.nodePackages_6_x;
  };

  self = allPkgs // utils;

in self
