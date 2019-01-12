{ stdenv, fetchurl, bash, cmake, pkgconfig, curl, cacert, unzip, zlib, lzma, bzip2, tbb, jemalloc, boost }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "salmon";
  version = "0.12.0";

  src = fetchurl {
    url = "https://github.com/COMBINE-lab/salmon/archive/v${version}.tar.gz";
    sha256 = "18zgky3fm3wcgjh5r2dq88p11xvr1cyczgmsqqpc3d5hqppx3swi";
  };

  nativeBuildInputs = [ bash cmake pkgconfig curl cacert unzip ];
  buildInputs = [ zlib lzma bzip2 tbb jemalloc boost ];

  preConfigure = ''
    for i in scripts/*.sh; do
      substituteInPlace $i --replace /bin/bash $shell
    done
    substituteInPlace CMakeLists.txt --replace \
      'set(Boost_USE_STATIC_LIBS ON)' \
      'set(Boost_USE_STATIC_LIBS OFF)'
  '';

  meta = with stdenv.lib; {
    description = "Highly-accurate & wicked fast transcript-level quantification from RNA-seq reads using lightweight alignments";
    license = licenses.gpl3;
    homepage = https://combine-lab.github.io/salmon;
    platforms = platforms.unix;
    maintainers = [ maintainers.bmpvieira ];
  };
}
