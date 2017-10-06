# Use like `nix-build -A dockerTar --argstr pkg 'htop'
# then `docker load < result`
# docker run -ti htop-2.0.2:2.0.2-nix17.09-beta /bin/sh # try htop then exit
# docker export $(docker ps -lq) | gzip > htop.tar.gz
# singularity exec htop.tar.gz htop

{ pkg, coreutils, which, gnugrep, gzip, gnused, curl, wget, gawk, shellDir, source, dockerTools, busybox }:

let
  shell = import shellDir;
  version = pkg.version or (
    if pkg.name == shell.name
    then shell.version
    else ""
  );
in
  dockerTools.buildImage rec {
    name = builtins.replaceStrings ["-${version}"] [""] "${pkg.name}";
    tag = "${version}_nix${source.version}";
    contents = [ pkg coreutils which gnugrep gzip gnused curl wget gawk ];
  }
