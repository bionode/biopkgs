with import ./default.nix {};

stdenv.mkDerivation rec {
  name = "YYYY.client.projectNumber.optionalCodename-${version}";
  baseName = "bash";
  version = "1.0.0";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [
    coreutils bash which gnugrep gzip gnused curl wget gawk
  ];
}
