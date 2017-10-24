#!/usr/bin/env fish
# Better Nix UI
# Usage: source ./nixez.fish

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

function read_confirm
  while true
    read -p 'echo "Confirm? (y/n):"' -l confirm

    switch $confirm
      case Y y
        return 0
      case '' N n
        return 1
    end
  end
end

function nixez
  switch $argv[1]
  case shell
    nix-shell
  case search
    nix-env -qaP ".*$argv[2].*"
  case install
    nix-env -f (pwd) -iA $argv[2]
  case remove
    nix-env -e $argv[2]
  case list
    nix-env -q
  case build
    nix-build (pwd) -A $argv[2]
  case nodejs
    cd pkgs/development/node-packages
    node2nix -6 -i node-packages-v6.json -o node-packages-v6.nix -c composition-v6.nix
    cd ../../..
  case docker
    nix-build (pwd) -A dockerTar --argstr pkg $argv[2]
    and docker-load-nix interactive
  case singularity
    nix-build (pwd) -A dockerTar --argstr pkg $argv[2]
    and docker-load-nix
    set NAME (docker ps -l --format "{{.Image}}" | sed 's|:|_|')
    and docker export (docker ps -lq) | gzip > $NAME.tar.gz
  case setup
    echo "This will install Nix"
    if read_confirm
      curl -o install-nix-1.11.15 https://nixos.org/nix/install
      curl -o install-nix-1.11.15.sig https://nixos.org/nix/install.sig
      gpg --recv-keys B541D55301270E0BCF15CA5D8170B4726D7198DE
      gpg --verify ./install-nix-1.11.15.sig; and sh ./install-nix-1.11.15
    end
  case unsafe-setup
    echo "This will install Nix without checking signature"
    if read_confirm
      curl https://nixos.org/nix/install | sh
    end
  case '*'
    echo "Options: shell, search, install, remove, list, build, docker, singularity, setup, unsafe-setup"
  end
end
