{ stdenv, fetchFromGitHub, openssl, gcc49 }:

stdenv.mkDerivation rec {
  name = "udr-${version}";
  version = "7f6a655"; # Git commit from April 6, 2017

  src = fetchFromGitHub {
    owner = "LabAdvComp";
    repo = "UDR";
    rev = "7f6a65575ba860dbe7a41380c1a62363ddf6fb25";
    sha256 = "1y7pgp1p2hfaxxsl8n6c8j86q3h2hvrlsrj1x0g8k93xpf8ps6pv";
  };

  buildInputs = [ openssl gcc49 ];

  buildPhase = ''
    cd ./udt
    make
    cd ../src
    make
    cd ..
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r src/udr $out/bin/
  '';

  fixupPhase = ''
    echo doing nothing
  '';

  meta = with stdenv.lib; {
    description = "A UDT wrapper for rsync that improves throughput of large data transfers over long distances.";
    homepage = https://github.com/LabAdvComp/UDR;
    license = stdenv.lib.licenses.asl20;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
    broken = true;
  };
}
