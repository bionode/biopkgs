{ stdenv, fetchurl, makeWrapper,
  cmake, autoconf, pkgconfig,
  cudatoolkit, linuxPackages,
  bash, curl, unzip, bzip2, lzma,
  boost, tbb, jemalloc }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "salmon";
  version = "0.12.0";

  src = fetchurl {
    url = "https://github.com/COMBINE-lab/salmon/archive/v${version}.tar.gz";
    sha256 = "1dr8maifd6hv45812l4w244npxmd2v73fzqmngs12amb2lq1jzxm";
  };

  buildInputs = [
    makeWrapper
    cmake autoconf pkgconfig
    cudatoolkit linuxPackages.nvidia_x11
    bash curl unzip bzip2 lzma
    boost tbb jemalloc
  ];

  CUDA_PATH = "${cudatoolkit}";

  preConfigure = ''
    for i in scripts/*.sh; do
      substituteInPlace $i --replace /bin/bash ${bash}/bin/bash
    done

    substituteInPlace CMakeLists.txt --replace \
      'set(Boost_USE_STATIC_LIBS ON)' \
      'set(Boost_USE_STATIC_LIBS OFF)'
  '';

  installTargets = "install-bin install-doc";

  meta = with stdenv.lib; {
    description = "Highly-accurate & wicked fast transcript-level quantification from RNA-seq reads using lightweight alignments";
    license = licenses.gpl3;
    homepage = https://combine-lab.github.io/salmon;
    platforms = platforms.unix;
    maintainers = [ maintainers.bmpvieira ];
  };
}
