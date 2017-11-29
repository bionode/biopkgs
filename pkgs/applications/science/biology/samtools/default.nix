{ stdenv, fetchurl, zlib, htslib, perl, ncurses ? null }:

stdenv.mkDerivation rec {
  name = "${pname}-${upstreamVersion}";
  pname = "samtools";
  upstreamVersion = "1.6";
  version = "${upstreamVersion}-perl";

  src = fetchurl {
    url = "https://github.com/samtools/samtools/releases/download/${upstreamVersion}/${name}.tar.bz2";
    sha256 = "17p4vdj2j2qr3b2c0v4100h6cg4jj3zrb4dmdnd9d9aqs74d4p7f";
  };

  buildInputs = [ zlib ncurses htslib perl];

  configureFlags = [ "--with-htslib=${htslib}" ]
    ++ stdenv.lib.optional (ncurses == null) "--without-curses";

  preCheck = ''
    patchShebangs test/
  '';

  enableParallelBuilding = false;

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tools for manipulating SAM/BAM/CRAM format";
    license = licenses.mit;
    homepage = http://www.htslib.org/;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimadrid ];
  };
}
