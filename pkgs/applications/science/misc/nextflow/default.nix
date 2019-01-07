{ stdenv, fetchurl, bash, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "nextflow";
  version = "18.10.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://www.nextflow.io/releases/v${version}/nextflow-${version}-one.jar";
    sha256 = "0r6sfzgrc3gmjprn8dgyjs1j94f3kyfly3gvry33yvdpn737h668";
  };

  propagatedBuildInputs = [ bash jre makeWrapper ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    mkdir ${name}
    cp $src ${name}/nextflow
    cd ${name}
    chmod +x nextflow
  '';

  installPhase = ''
    mkdir -p $out/libexec/nextflow
    cp $src $out/libexec/nextflow/nextflow.jar
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/nextflow --add-flags "-jar $out/libexec/nextflow/nextflow.jar"
  '';

  meta = with stdenv.lib; {
    description = "A DSL for data-driven computational pipelines";
    homepage = https://www.nextflow.io;
    license = licenses.gpl3;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
  };
}
