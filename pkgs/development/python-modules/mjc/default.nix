{ lib
, buildPythonPackage
, fetchPypi
, matplotlib
}:

buildPythonPackage rec {
  pname = "mjc";
  version = "1.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zkaxcq4xv5irswrph8c4zggkmdcdwrh3gn1d0xjh0bg1a7491ac";
  };

  propagatedBuildInputs = [ matplotlib ];

  meta = with lib; {
    description = "Minimum Jump Cost dissimilarity algorithm";
    homepage =  https://github.com/nup002/mjc/;
    license = licenses.free;
    maintainers = with maintainers; [ bmpvieira ];
  };
}