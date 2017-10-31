#!/usr/bin/env bash
# Better Nix UI
# Usage: source ./nixez.sh

function docker-load-nix() {
  if grep -q -s Microsoft /proc/version; then
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

  # docker run $ARGS -v "$DIR:/data" "$IMAGE"
}

function nixez() {
  case $1 in
    shell) nix-shell ;;
    search) nix-env -qaP ".*$2.*" ;;
    install) nix-env -f "$(pwd)" -iA "$2" ;;
    remove) nix-env -e "$2" ;;
    list) nix-env -q;;
    build) nix-build "$(pwd)" -A "$2" ;;
    nodejs)
      cd pkgs/development/node-packages
      node2nix -6 -i node-packages-v6.json -o node-packages-v6.nix -c composition-v6.nix
      cd ../../..
    ;;
    docker)
      if [ "$(uname)" == "Darwin" ]; then
        sudo $(cat ~/.nixpkgs/linuxkit-builder/env) \
        NIX_PATH="nixpkgs=$HOME/.nix-defexpr/channels/nixpkgs" \
        nix-build "$(pwd)" -A dockerTar --argstr pkg "$2" \
          --argstr timestamp $(date -u +"%Y-%m-%dT%H:%M:%SZ") \
          --argstr system "x86_64-linux"
      else
        nix-build "$(pwd)" -A dockerTar --argstr pkg "$2" \
          --argstr timestamp $(date -u +"%Y-%m-%dT%H:%M:%SZ")
      fi
      if [ -t 0 ]; then
        docker-load-nix interactive
      else
        docker-load-nix
      fi
    ;;
    docker-push)
      nix-build "$(pwd)" -A dockerTar --argstr pkg "$2" &&
      docker-load-nix
    ;;
    singularity)
      nix-build "$(pwd)" -A dockerTar --argstr pkg "$2" &&
      docker-load-nix &&
      NAME=$(docker ps -l --format "{{.Image}}" | sed 's|:|_|')
      docker export "$(docker ps -lq)" | gzip > "$NAME.tar.gz"
    ;;
    setup)
      read -r -p "This will install Nix, are you sure? [y/N]" response
      case "$response" in
        [yY][eE][sS]|[yY])
          curl -o install-nix-1.11.15 https://nixos.org/nix/install
          curl -o install-nix-1.11.15.sig https://nixos.org/nix/install.sig
          gpg --recv-keys B541D55301270E0BCF15CA5D8170B4726D7198DE
          gpg --verify ./install-nix-1.11.15.sig && sh ./install-nix-1.11.15
        ;;
        *)
          echo "Canceled"
        ;;
      esac
    ;;
    unsafe-setup)
      read -r -p "This will install Nix without checking signature, are you sure? [y/N]" response
      case "$response" in
        [yY][eE][sS]|[yY])
          curl https://nixos.org/nix/install | sh
        ;;
        *)
          echo "Canceled"
        ;;
      esac
    ;;
    repair)
      nix-store --verify --check-contents
    ;;
    * ) echo "Options: shell, search, install, remove, list, build, docker, singularity" ;;
  esac
}
