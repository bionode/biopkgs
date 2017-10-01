{ stdenv, fetchcvs, libtool, autoreconfHook, }:

stdenv.mkDerivation rec {
  name = "tsunami-udp-${version}";
  version = "2016-02-25";

  src = fetchcvs {
    cvsRoot = ":pserver:anonymous@tsunami-udp.cvs.sourceforge.net:/cvsroot/tsunami-udp";
    module = "tsunami-udp";
    date = version;
    sha256 = "0k0gv89a6vzdi0c3mb829r48asbf9sbrc3kgc12b1qfrxcxqnjpj";
  };

  buildInputs = [ libtool autoreconfHook ];

  buildPhase = ''
    ./recompile.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    DESTDIR=/tmp make install
    mv /tmp/usr/local/bin $out/
  '';

  meta = with stdenv.lib; {
    description = " A fast user-space file transfer protocol that uses TCP control and UDP data for transfer over very high speed long distance networks";
    homepage = http://tsunami-udp.sourceforge.net/;
    license = stdenv.lib.licenses.free;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
  };
}
