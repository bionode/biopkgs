{ stdenv, fetchFromGitHub, zlib, gsl, dmd }:

stdenv.mkDerivation rec {
  pname = "msmc";
  version = "19d47d9"; # Git commit from September 6, 2017
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "stschiff";
    repo = "msmc";
    rev = "19d47d91642baa5fbef3bef04bc941a9f6681375";
    sha256 = "10hbs94svx7jqm8rh0qaas4akz6lsmj055k7kaxf05bxsrkb4vv4";
  };

  preBuild = ''
    substituteInPlace Makefile --replace \
      'GSL=/usr/local/lib/libgsl.a /usr/local/lib/libgslcblas.a' \
      'GSL=${gsl}/lib/libgsl.so ${gsl}/lib/libgslcblas.so'
  '';

  buildInputs = [ zlib gsl dmd];

  installPhase = ''
    mkdir -p $out/bin
    cp build/msmc $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Implementation of the multiple sequential markovian coalescent";
    homepage = https://github.com/stschiff/msmc;
    license = licenses.gpl3;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
  };
}
