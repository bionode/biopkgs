{ stdenv, fetchurl, zlib, perl, libxml2, file, hdf5, ngs, makeWrapper, bash, bc, bison }:

stdenv.mkDerivation rec {
  pname = "ncbi-vdb";
  version = "2.9.3";
  name = "${pname}-${version}";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/ncbi/ncbi-vdb/archive/${version}.tar.gz";
    sha256 = "13mr9jsl6q5y8b897masrls0i3kwi68v3qssbir329fnkc80l2hh";
  };

  buildInputs = [ zlib perl libxml2 file/*provides libmagic*/ hdf5 ngs makeWrapper bash bc bison ];

 # patches = [
 #   ./remove_flags.patch
 # ];

  preBuild = ''
    for i in build/*.sh; do
      substituteInPlace $i --replace /bin/bash ${bash}/bin/bash
    done
  '';

  hardeningDisable = [ "all" ];

  setOutputFlags = false;
  dontPatchELF = true;

  configureFlags = ''
    --with-magic-prefix=${file}
    --with-hdf5-prefix=${hdf5}
    --build-prefix _build
    --with-xml2-prefix=${libxml2.dev}
    --with-ngs-sdk-prefix=${ngs}
  '';


  postFixup = ''
    # Sources needed for dependents like sra-tools
    mkdir -p $out/src/ncbi-vdb
    mv * $out/src/ncbi-vdb
  '';


  meta = with stdenv.lib; {
    description = "Tools and libs for data in the INSDC Sequence Read Archives";
    homepage = https://github.com/ncbi/ncbi-vdb;
    license = stdenv.lib.licenses.publicDomain;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
  };
}
