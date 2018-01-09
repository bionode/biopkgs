{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  pname = "shapeit-bin";
  version = "2.r837";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://mathgen.stats.ox.ac.uk/genetics_software/shapeit/shapeit.v${version}.GLIBCv2.12.Linux.static.tgz";
    sha256 = "094bwngq8r4hpf90drh4xwmaprnxc7nfaj897ydzxl46m251fi1s";
  };

  sourceRoot = ".";

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/shapeit $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A fast and accurate method for estimation of haplotypes (aka phasing) from genotype or sequencing data.";
    homepage = https://mathgen.stats.ox.ac.uk/genetics_software/shapeit/shapeit.html;
    license = licenses.free;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = ["x86_64-linux"];
  };
}
