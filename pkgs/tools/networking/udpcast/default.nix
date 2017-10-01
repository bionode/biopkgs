{ stdenv, fetchurl, gzip, m4, perl }:

stdenv.mkDerivation rec {
  name = "udpcast-${version}";
  version = "20120424";

  src = fetchurl {
    url = "http://www.udpcast.linux.lu/download/udpcast-20120424.tar.gz";
    sha256 = "0nj46swgryv6f8km7zrr5jlvm68wwqsw6nlv99s5l0xnh3pr146f";
  };
  buildInputs = [ gzip m4 perl];

  patches = [
    ./fix-fd_set-error.patch
  ];

  meta = with stdenv.lib; {
    description = "A file transfer tool that can send data simultaneously to many destinations on a LAN.";
    homepage = http://www.udpcast.linux.lu;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
  };
}
