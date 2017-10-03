{ stdenv, fetchurl, gzip, zlib, openssl }:

stdenv.mkDerivation rec {
  name = "bbcu-${version}";
  version = "15.02.03.00.1";

  src = fetchurl {
    url = "http://www.slac.stanford.edu/~abh/bbcp/bbcp.tgz";
    sha256 = "1ppd30ab5bwmixrb6iwvv3mx87jslq0j0dgq33nx7dklpx1fkwkx";
  };
  buildInputs = [ gzip zlib openssl ];

  buildPhase = ''
    cd src
    make
    cd ..
  '';

  installPhase = ''
    mkdir -p $out/bin/
    cp bin/amd64_linux/bbcp $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Securely and quickly copy data from source to target";
    homepage = http://www.slac.stanford.edu/~abh/bbcp/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.x86_64;
  };
}
