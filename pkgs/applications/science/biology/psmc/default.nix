{ stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  baseName = "psmc";
  version = "e5f7df5"; # Git commit from January 21, 2016
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "lh3";
    repo = "psmc";
    rev = "e5f7df5d00bb75ec603ae0beff62c0d7e37640b9";
    sha256 = "1fh8vhrjabyc4vsgy7fqy24r83557vzgj3a3w4353nljdgz1q4il";
  };

  buildInputs = [ zlib ];
  buildPhase = ''
    make
    cd utils; make; cd ..
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp psmc $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Implementation of the Pairwise Sequentially Markovian Coalescent (PSMC) model";
    homepage = https://github.com/lh3/psmc;
    license = licenses.mit;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
  };
}
