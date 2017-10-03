{ stdenv, fetchurl, zlib, perl, libxml2, file, hdf5, ngs, ncbi-vdb }:

stdenv.mkDerivation rec {
  name = "sra-tools-${version}";
  version = "2.8.2-3";

  src = fetchurl {
    url = "https://github.com/ncbi/sra-tools/archive/${version}.tar.gz";
    sha256 = "1yljhydg2wphk13iadkwhs48mqqs1ki4961njws7r6636pbmyknh";
  };

  buildInputs = [ zlib perl libxml2.dev file/*provides libmagic*/ hdf5 ngs ncbi-vdb];

  enableParallelBuilding = false;

  patches = [
    ./fix-naming-conflict.patch
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

  meta = with stdenv.lib; {
    description = "A collection of tools and libraries for using data in the INSDC Sequence Read Archives";
    homepage = https://github.com/ncbi/sra-tools;
    license = stdenv.lib.licenses.publicDomain;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = stdenv.lib.platforms.linux;
  };
}
