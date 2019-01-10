{ system ? builtins.currentSystem }:

let
  pinPkgs = import (builtins.fetchTarball {
    name = "nixos-18.09";
    url = "https://github.com/NixOS/nixpkgs/archive/18.09.tar.gz";
    sha256 = "1ib96has10v5nr6bzf7v8kw7yzww8zanxgw2qi1ll1sbv6kj6zpd";
  }) { inherit system; };

  pkgs = pinPkgs // {
    stdenv = pinPkgs.stdenv.overrideDerivation (attrs: attrs // {
      lib = attrs.lib // {
        maintainers = import ../../lib/maintainers.nix {};
      };
    });
  };

  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xlibs // self);

  rPackages = callPackage ../development/r-modules { overrides = (p: {}) pkgs; };

  pythonGenerated = (import ../development/python-modules/requirements.nix { inherit pkgs; }).packages;
  python36Packages = pkgs.python36Packages // pythonGenerated;
  pythonPackages = python36Packages;
  python = pkgs.python3;

  nodePackages_10_x = callPackage ../development/node-packages/default-v10.nix {
    nodejs = pkgs.nodejs-10_x;
  };
  nodePackages = nodePackages_10_x;
  nodejs = pkgs.nodejs-10_x;

  languagesModules = {
    rPackages = rPackages;
    python36Packages = python36Packages;
    pythonPackages = pythonPackages;
    python = python;
    nodePackages = nodePackages;
    nodejs = nodejs;
  };

  customPkgs = {
    # Workflows
    nextflow = callPackage ../applications/science/misc/nextflow {};
    # Cuda aligners
    arioc = callPackage ../applications/science/biology/arioc {};
    salmon = callPackage ../applications/science/biology/salmon {};
    # SRA
    sra-tools = callPackage ../applications/science/biology/sra-tools {};
    ncbi-vdb = callPackage ../applications/science/biology/ncbi-vdb {}; # sra-tools dep
    ngs = callPackage ../applications/science/biology/ngs {}; # sra-tools dep
    # QC
    seqtk = callPackage ../applications/science/biology/seqtk {};
    fastqc = callPackage ../applications/science/biology/fastqc {};
    trimmomatic = callPackage ../applications/science/biology/trimmomatic {};
    # K-mers
    kmc = callPackage ../applications/science/biology/kmc {};
    # Population genomics
    psmc = callPackage ../applications/science/biology/psmc {};
    msmc = callPackage ../applications/science/biology/msmc {};
    # msmc-bin = callPackage ../applications/science/biology/msmc-bin {};
    # msmc2 = callPackage ../applications/science/biology/msmc2 {};
    # msmc-tools = callPackage ../applications/science/biology/msmc-tools {};
    seqbility = callPackage ../applications/science/biology/seqbility {}; # msmc dep

    # bbcp = callPackage ../tools/networking/bbcp {};
    # aspera = callPackage ../tools/networking/aspera {};
    # shapeit-bin = callPackage ../applications/science/biology/shapeit-bin {};
    # htslib = callPackage ../development/libraries/science/biology/htslib {};
    # seqlib = callPackage ../applications/science/biology/seqlib {};
    # tsunami-udp = callPackage ../tools/networking/tsunami-udp {};
    # udpcast = callPackage ../tools/networking/udpcast {};
    # udr = callPackage ../tools/networking/udr {};
    # python36Packages = callPackage ./python-packages.nix {};
    # nodejs = hiPrio nodejs-6_x;
    # nodePackages_6_x = callPackage ../development/node-packages/default-v6.nix {
      # nodejs = pkgs.nodejs-6_x;
    # };
  };

  containerReadyPkgs = {
  };

  # customEnvs = {
  #   # shell = (import shellDir).env;
  # };

  # allPkgs = pkgs // customPkgs // containerReadyPkgs // customEnvs;

  # utils = {
    # source = source;
    # containerReadyPkgs = containerReadyPkgs;
    # dockerTar = callPackage ./dockerTar.nix { inherit timestamp; pkg=allPkgs."${pkg}"; shellDir=(builtins.toPath shellDir); };
    # nodePackages = customPkgs.nodePackages_6_x;
  # };

  # self = allPkgs // utils;
  self = pkgs // languagesModules // customPkgs;
in self
