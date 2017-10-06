{ stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  name = "seqtk-${version}";
  version = "32e7903"; # Git commit from February 11, 2017

  src = fetchFromGitHub {
    owner = "lh3";
    repo = "seqtk";
    rev = "32e7903e8fd36cf8975a05295156cc69ca57c82b";
    sha256 = "1q12bq6sbpvr07vfi8ls2hi2d997frab6g61ijcv8z9wzksnrgpz";
  };

  buildInputs = [ zlib ];

  installPhase = ''
    mkdir -p $out/bin
    cp seqtk $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Toolkit for processing sequences in FASTA/Q formats";
    homepage = https://github.com/lh3/seqtk;
    license = licenses.mit;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
  };
}
