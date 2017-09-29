#!/usr/bin/env fish
# Better Nix UI
# Usage: source ./nix.fish

function docker-load-nix
  if test -n (cat /proc/version | grep Microsoft)
    set DIR (pwd | sed 's|/mnt/\(.\)|\1:|' | sed 's|/|\\\|g')
  else
    set DIR (pwd)
  end

  set IMAGE (docker load < result | awk '{print $3}')

  if test $argv[1] -a $argv[1] = "interactive"
    set ARGS -ti --rm
  end

  docker run $ARGS -v $DIR:/data $IMAGE /bin/sh
end

function nix
  switch $argv[1]
  case shell 
    nix-shell
  case install
    nix-env -f (pwd) -iA $argv[2]
  case build
    nix-build (pwd) -A $argv[2]
  case docker
    nix-build (pwd) -A dockerTar --argstr pkg $argv[2]
    and docker-load-nix interactive
  case singularity
    nix-build (pwd) -A dockerTar --argstr pkg $argv[2]
    and docker-load-nix
    set NAME (docker ps -l --format "{{.Image}}" | sed 's|:|_|')
    and docker export (docker ps -lq) | gzip > $NAME.tar.gz
  case '*'
    echo "Options: shell, install, build, docker, singularity"
  end
end
