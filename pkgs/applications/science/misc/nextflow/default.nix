{ stdenv, fetchurl, bash, jre }:

stdenv.mkDerivation rec {
  name = "nextflow-${version}";
  version = "0.25.7";

  src = fetchurl {
    url = "https://www.nextflow.io/releases/v${version}/nextflow";
    sha256 = "1h57rccm03sfb6qs0vgr7f8jkk676lc7iwppqg20ll00r9dnk8br";
  };

  propagatedBuildInputs = [ bash jre ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    mkdir ${name}
    cp $src ${name}/nextflow
    cd ${name}
    chmod +x nextflow
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv nextflow $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A DSL for data-driven computational pipelines";
    homepage = https://www.nextflow.io;
    license = licenses.gpl3;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
  };
}
