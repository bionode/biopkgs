#/bin/bash
# Better Nix UI
# Usage: source ./nix.sh

function docker-load-nix() {
  if [[ -n $(cat /proc/version | grep Microsoft) ]]; then
    DIR=$(pwd | sed 's|/mnt/\(.\)|\1:|' | sed 's|/|\\|g')
  else
    DIR=$(pwd)
  fi

  IMAGE=$(docker load < result | awk '{print $3}')

  if [[ $1 == "interactive" ]]; then
    ARGS="-ti --rm"
  else
    ARGS=""
  fi

  docker run $ARGS -v $DIR:/data $IMAGE /bin/sh
}

function nix() {
  case $1 in
    shell) nix-shell;;
    install) nix-env -f $(pwd) -iA $2;;
    build) nix-build $(pwd) -A $2;;
    docker)
      nix-build $(pwd) -A dockerTar --argstr pkg $2 && 
      docker-load-nix interactive
    ;;
    singularity)
      nix-build $(pwd) -A dockerTar --argstr pkg $2 && 
      docker-load-nix &&
      NAME=$(docker ps -l --format "{{.Image}}" | sed 's|:|_|')
      docker export $(docker ps -lq) | gzip > $NAME.tar.gz
    ;;
    * ) echo "Options: shell, install, build, docker, singularity" ;;
  esac
}
