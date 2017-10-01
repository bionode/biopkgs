{ stdenv, fetchurl, unzip, jre }:

stdenv.mkDerivation rec {
  name = "fastqc-${version}";
  version = "0.11.5";

  src = fetchurl {
    url = "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v${version}.zip";
    sha256 = "0rmx5hl7752dbrgka27dfychs70n1xgf7zynys65ilpf1kc5lynx";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/opt
    chmod +x fastqc
    cp -r ../$sourceRoot $out/opt/fastqc
    ln -s $out/opt/fastqc/fastqc $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A quality control tool for high throughput sequence data";
    homepage = https://www.bioinformatics.babraham.ac.uk/projects/fastqc/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bmpvieira ];
    platforms = platforms.all;
  };
}
