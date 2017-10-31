#! /bin/bash
source ./nixez.sh
repo=bionode
nix-env -f . -qaPA 'customPkgs' | awk '{print $2}' | while read pkg; do
  echo "Checking if $pkg needs to be pushed to Docker Hubs"
  pkgName=${pkg%%-*}
  pkgVersion=${pkg##*-}
  url="https://registry.hub.docker.com/v2/repositories/$repo/$pkgName/tags/"
  if ! curl -s $url | jq '."results"[]["name"]' 2> /dev/null | grep -q $pkgVersion ; then
    echo "Building Docker image for $pkg"
    nixez docker $pkgName
    echo "Pushing $pkg to Docker Hub"
    docker tag $repo/$pkgName:$pkgVersion $repo/$pkgName:latest
    docker push $repo/$pkgName
  fi
done