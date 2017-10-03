{ stdenv, fetchurl, unzip, jre, makeWrapper }:

stdenv.mkDerivation rec {
  name = "trimmomatic-${version}";
  version = "0.36";

  src = fetchurl {
    url = "http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-${version}.zip";
    sha256 = "1zkhkzmgqnlfqn916adz333rzj5fl86z7km8sgbbjqxn8wiw8ij8";
  };

  buildInputs = [ unzip makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/java
    cp ${name}.jar $out/share/java/
    mkdir -p $out/share/trimmomatic/adapters/
    cp adapters/* $out/share/trimmomatic/adapters/
    makeWrapper ${jre}/bin/java $out/bin/trimmomatic --add-flags "-jar $out/share/java/${name}.jar"
  '';

  meta = with stdenv.lib; {
    description = "A flexible read trimming tool for Illumina NGS data";
    homepage = http://www.usadellab.org/cms/?page=trimmomatic;
    license = licenses.free;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
  };
}
