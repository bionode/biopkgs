{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kmc";
  version = "291aacc"; # Git commit from Mar 1, 2018
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "refresh-bio";
    repo = "KMC";
    rev = "291aacc33a0ebef7178b62218ae9b23c8c576d8d";
    sha256 = "0538xayl7zwggwyhgbwqf4yd023bkyxwgz92pkx3gjxk41m7dgcl";
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
