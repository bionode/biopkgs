{ stdenv, fetchFromGitHub, zlib, gsl, dmd }:

stdenv.mkDerivation rec {
  pname = "msmc2";
  version = "18733d7"; # Git commit from September 6, 2017
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "stschiff";
    repo = "msmc2";
    rev = "18733d73b77ce2cd270cbe7a51223484e0695515";
    sha256 = "1jqw98878kic1smp9ai977hz4hnnpfdnpkc44ckpm15qwbaqddwf";
  };

  preBuild = ''
    substituteInPlace Makefile --replace \
      'GSLDIR=/usr/lib' \
      'GSLDIR=${gsl}/lib'
    substituteInPlace Makefile --replace \
      'libgsl.a' \
      'libgsl.so'
    substituteInPlace Makefile --replace \
      'libgslcblas.a' \
      'libgslcblas.so'
  '';

  buildInputs = [ zlib gsl dmd];

  installPhase = ''
    mkdir -p $out/bin
    cp build/release/msmc2 $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Implementation of the multiple sequential markovian coalescent";
    homepage = https://github.com/stschiff/msmc2;
    license = licenses.gpl3;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
  };
}
