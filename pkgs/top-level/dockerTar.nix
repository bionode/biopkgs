{ pkg, shellDir, source, dockerTools, timestamp, busybox }:

let
  shell = import shellDir;
  version = pkg.version or (
    if pkg.name == shell.name
    then shell.version
    else ""
  );
  baseName = pkg.baseName or (
    if pkg.name == shell.name
    then shell.baseName
    else ""
  );
in
  dockerTools.buildImage rec {
    name = "bionode/" + builtins.replaceStrings ["-${version}"] [""] "${pkg.name}";
    tag = "${version}_nix${source.version}";
    contents = [ pkg busybox ];
    created = timestamp;
    config = {
      Cmd = [ "${pkg}/bin/${baseName}" ];
    };
  }
