{ stdenv, fetchFromGitHub, zlib, python }:

stdenv.mkDerivation rec {
  pname = "msmc-tools";
  version = "12758d9"; # Git commit from April 20, 2017
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "stschiff";
    repo = "msmc-tools";
    rev = "12758d9283f47fee173eab840c3ce364c6eb3495";
    sha256 = "0kd6x7dsjfg306qppipjbdmpqfhqlx16zhkj7vq5a59mrinrav2n";
  };

  buildInputs = [ zlib python ];

  patches = [
    ./makeMappabilityMask.py.patch
  ];

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp *.py $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Tools and Utilities for msmc and msmc2";
    homepage = https://github.com/stschiff/msmc-tools;
    license = licenses.unlicense;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
  };
}
