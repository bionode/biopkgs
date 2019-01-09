{ stdenv, fetchurl, zlib, perl, libxml2, file, hdf5, ngs, ncbi-vdb, bash, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "sra-tools";
  version = "2.9.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/ncbi/sra-tools/archive/${version}.tar.gz";
    sha256 = "0fygqdk968yj72z5k5w2gqy4m23m2phj83a7dqy1df60w4g0jmg0";
  };

  buildInputs = [ zlib perl libxml2.dev file/*provides libmagic*/ hdf5 ngs ncbi-vdb bash makeWrapper ];

  enableParallelBuilding = false;

  patches = [
   #./fix-naming-conflict.patch
   ./do-not-link-libxml2-statically.patch
   ./remove-ld-static.patch
  ];

  configureFlags = ''
    --build-prefix _build
    --with-xml2-prefix=${libxml2.dev}
    --with-hdf5-prefix=${hdf5}
    --with-magic-prefix=${file}
    --with-ngs-sdk-prefix=${ngs}
    --with-ncbi-vdb-build=${ncbi-vdb}/src/ncbi-vdb/_build
    --with-ncbi-vdb-source=${ncbi-vdb}/src/ncbi-vdb
  '';

  preBuild = ''
    for i in build/*.sh; do
      substituteInPlace $i --replace /bin/bash ${bash}/bin/bash
    done
  '';

  meta = with stdenv.lib; {
    description = "A collection of tools and libraries for using data in the INSDC Sequence Read Archives";
    homepage = https://github.com/ncbi/sra-tools;
    license = stdenv.lib.licenses.publicDomain;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = stdenv.lib.platforms.linux;
  };
}
