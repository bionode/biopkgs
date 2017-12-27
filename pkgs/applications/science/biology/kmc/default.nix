{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kmc";
  version = "f25a1af"; # Git commit from August 8, 2017
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "refresh-bio";
    repo = "KMC";
    rev = "f25a1af7bb70aa4f17692848b333e84812ca9363";
    sha256 = "0wzqhw4dkl9vpwnrc59ya1j0l8z9ccipmr2mjmmymbzyvclg0033";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bin/kmc $out/bin/
    cp bin/kmc_dump $out/bin/
    cp bin/kmc_tools $out/bin/
  '';

  patches = [
    ./remove-static-flags.patch
  ];

  meta = with stdenv.lib; {
    description = "Fast and frugal disk based k-mer counter";
    homepage = http://sun.aei.polsl.pl/kmc/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
  };
}
