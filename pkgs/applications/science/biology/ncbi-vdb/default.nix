{ stdenv, fetchurl, zlib, perl, libxml2, file, hdf5, ngs }:

stdenv.mkDerivation rec {
  pname = "ncbi-vdb";
  version = "2.8.2-2";
  name = "${pname}-${version}";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/ncbi/ncbi-vdb/archive/${version}.tar.gz";
    sha256 = "159wiw6fnmw772rlpphmwnyl4vayg0adqg7bb2mgld8fy2mzfrkq";
  };

  buildInputs = [ zlib perl libxml2 file/*provides libmagic*/ hdf5 ngs ];

  patches = [
    ./remove_flags.patch
  ];

  hardeningDisable = [ "all" ];

  setOutputFlags = false;
  dontPatchELF = true;

  configureFlags = ''
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
