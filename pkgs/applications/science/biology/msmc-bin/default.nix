{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "msmc-bin";
  version = "1.0.0";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/stschiff/msmc/releases/download/v${version}/msmc_${version}_linux64bit";
    sha256 = "0922rhbry471d4z76q3yhkjl1bplrff2nfy4mcpzjbizwg9wzn5r";
    executable = true;
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/msmc
  '';

  meta = with stdenv.lib; {
    description = "Implementation of the multiple sequential markovian coalescent";
    homepage = https://github.com/stschiff/msmc;
    license = licenses.gpl3;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = ["x86_64-linux"];
  };
}
