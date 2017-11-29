{ stdenv, fetchurl, htslib, zlib, bzip2, lzma, curl, perl, bash }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "bcftools";
  upstreamVersion = "1.6";
  version = "${upstreamVersion}noperl";

  src = fetchurl {
    url = "https://github.com/samtools/bcftools/releases/download/${upstreamVersion}/${pname}-${upstreamVersion}.tar.bz2";
    sha256 = "10prgmf09a13mk18840938ijqgfc9y92hfc7sa2gcv07ddri0c19";
  };

  buildInputs = [ htslib zlib bzip2 lzma curl ];

  makeFlags = [
    "HSTDIR=${htslib}"
    "prefix=$(out)"
    "CC=cc"
  ];

  meta = with stdenv.lib; {
    description = "Tools for manipulating BCF2/VCF/gVCF format, SNP and short indel sequence variants";
    license = licenses.mit;
    homepage = http://www.htslib.org/;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimadrid ];
  };
}
