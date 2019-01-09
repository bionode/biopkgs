{ stdenv, fetchzip, cudatoolkit, linuxPackages, makeWrapper }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "arioc";
  version = "1.30";

  src = fetchzip {
    url = "https://github.com/RWilton/Arioc/releases/download/v${version}/Arioc.x.130.zip";
    sha256 = "015qw8k1i512xrvhpd5rdcjq32yfmqsv6a3ggw7f0bwjm0fig1z7";
  };

  buildInputs = [ cudatoolkit linuxPackages.nvidia_x11 makeWrapper ];

  preBuild = ''
    export CUDA_PATH="${cudatoolkit}"
  '';

  buildPhase = ''
    sed -ie 's|/software/apps/cuda/9.2/bin/nvcc|${cudatoolkit}/bin/nvcc|' makefile
    make AriocE
    make AriocU
    make AriocP
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ../bin/AriocE $out/bin
    cp ../bin/AriocU $out/bin
    cp ../bin/AriocP $out/bin
    wrapProgram "$out/bin/AriocE" --prefix LD_LIBRARY_PATH ":" "${linuxPackages.nvidia_x11}/lib"
    wrapProgram "$out/bin/AriocU" --prefix LD_LIBRARY_PATH ":" "${linuxPackages.nvidia_x11}/lib"
    wrapProgram "$out/bin/AriocP" --prefix LD_LIBRARY_PATH ":" "${linuxPackages.nvidia_x11}/lib"
  '';

  meta = with stdenv.lib; {
    description = "High-throughput read alignment with GPU-accelerated exploration of the seed-and-extend search space";
    license = licenses.bsd2;
    homepage = https://github.com/RWilton/Arioc;
    platforms = platforms.unix;
    maintainers = [ maintainers.bmpvieira ];
  };
}
