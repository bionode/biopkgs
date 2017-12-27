{ stdenv, fetchurl, zlib, perl }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "seqbility";
  version = "20091110";

  src = fetchurl {
    url = "http://lh3lh3.users.sourceforge.net/download/${name}.tar.bz2";
    sha256 = "0cijfca0dmdhkzxnw2k7jm6vhlfifbnsrq66vynhds2xwhp3vdmi";
  };

  buildInputs = [ zlib perl ];

  installPhase = ''
    mkdir -p $out/bin
    cp gen_mask $out/bin/
    cp splitfa $out/bin/
    cp gen_raw_mask.pl $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Utilities to compute mappability";
    license = licenses.unlicense;
    homepage = http://lh3lh3.users.sourceforge.net/snpable.shtml;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
  };
}
