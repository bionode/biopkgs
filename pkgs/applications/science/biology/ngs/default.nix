{ stdenv, fetchurl, zlib, pkgconfig, perl
, withJava ? false, jdk
, withPython ? false, python, ncbi-vdb }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "ngs";
  version = "2.9.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/ncbi/ngs/archive/${version}.tar.gz";
    sha256 = "0zbmbyc746lmbfvqr4z0bz8lq1z9ahp242j9ri4y8rjc1wsdyv6i";
  };

  buildInputs = [ zlib perl]
    ++ optional withJava jdk
    ++ optional withPython [ python ncbi-vdb ];

  configureFlags = "--build-prefix build";

  buildPhase = "make -C ngs-sdk"
    + optionalString withJava ''

      cd ngs-java; ./configure; cd ..
      make -C ngs-java
    ''
    + optionalString withPython ''

      cd ngs-python
      ./configure \
        --build-prefix build \
        --prefix=$out/usr/local/ngs \
        --with-ncbi-vdb-prefix=${ncbi-vdb}
      cd ..
      make -C ngs-python
    '';

  installPhase = "make -C ngs-sdk install"
    + optionalString withJava ''

      make -C ngs-java install
    ''
    + optionalString withPython ''

      export HOME=$PWD
      make -C ngs-python install
    '';

  meta = with stdenv.lib; {
    description = "API for accessing NGS reads, alignments and pileups";
    homepage = https://github.com/ncbi/ngs;
    license = stdenv.lib.licenses.publicDomain;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
  };
}
