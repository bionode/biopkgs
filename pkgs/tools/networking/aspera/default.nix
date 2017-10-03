{ stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "aspera-${version}";
  version = "3.7.5";

  src = fetchurl {
    url = "http://download.asperasoft.com/download/sw/cli/${version}/aspera-cli-${version}.539.df4398f-linux-64-release.sh";
    sha256 = "0wxqimmzqbigz23nwwkhwvwcmgfb3yp8xvg4i0iwjw1h9aqddpwz";
  };

  buildInputs = [ makeWrapper ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    mkdir ${name}
    cp $src ${name}/install.sh
    cd ${name}
    chmod +x install.sh
  '';

  installPhase = ''
    export HOME=$PWD
    ./install.sh &> /dev/null
    cp -R .aspera/cli $out
    makeWrapper $out/bin/ascp $out/bin/ascp-ncbi --add-flags "-T -l640M -i $out/etc/asperaweb_id_dsa.openssh"
  '';

  meta = with stdenv.lib; {
    description = "A collection of Aspera tools for performing high-speed, secure data transfers from the command line.";
    homepage = http://downloads.asperasoft.com/en/downloads/62;
    license = licenses.unfree;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.x86_64;
  };
}
