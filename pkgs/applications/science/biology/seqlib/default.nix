{ stdenv, fetchgit, zlib, lzma, bzip2 }:

stdenv.mkDerivation rec {
  name = "seqlib-${version}";
  version = "8c22fbc"; # Git commit from August 6, 2017

  src = fetchgit {
    url = git://github.com/walaj/SeqLib.git;
    rev = "8c22fbc414cf145f86eadc26cc383ce461e16bd8";
    sha256 = "1wd7gq31lgyh8wwm61mrj98ji09a20k1arzbmkxkjzkcq9lhpyvy";
    fetchSubmodules = true;
  };

  buildInputs = [ zlib lzma bzip2 ];

  installPhase = "
    mkdir -p $out/bin
    make install
    make seqtools
    mv bin/seqtools $out/bin/
    mv bin $out/lib
  ";

  meta = with stdenv.lib; {
    description = "C++ htslib/bwa-mem/fermi interface for interrogating sequence data";
    homepage = https://github.com/walaj/SeqLib;
    license = stdenv.lib.licenses.asl20 ;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
  };
}
