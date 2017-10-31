#! /bin/bash
source ./nixez.sh
nixez install hello # To test and also get pinned Pkgs repo
repo=bionode
nixVersion=$(jq -r .version ./nixsrc.json)
nix-env -f . -qaPA 'customPkgs' | awk '{print $2}' | while read pkg; do
  echo "Checking if $pkg needs to be pushed to Docker Hubs"
  pkgName=${pkg%%-*}
  pkgVersion=${pkg##*-}
  dockerTag="$pkgVersion"_nix"$nixVersion"
  url="https://registry.hub.docker.com/v2/repositories/$repo/$pkgName/tags/"
  if ! curl -s $url | jq -r '."results"[]["name"]' 2> /dev/null | grep -q -e "^$dockerTag$" ; then
    echo "Building Docker image for $pkg"
    nixez docker $pkgName
    docker tag $repo/$pkgName:$dockerTag $repo/$pkgName:latest
    echo "Pushing $pkg to Docker Hub"
    docker push $repo/$pkgName
  fi
done