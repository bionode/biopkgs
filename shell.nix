with import ./default.nix {};

stdenv.mkDerivation rec {
  name = "YYYY.client.projectNumber.optionalCodename-${version}";
  version = "1.0.0";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [
  ];
}
