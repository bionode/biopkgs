# generated using pypi2nix tool (version: 1.8.1)
# See more at: https://github.com/garbas/pypi2nix
#
# COMMAND:
#   pypi2nix -v -V 3.6 -s numpy -r requirements.txt -E gfortran -E blas -E pkgconfig -E freetype.dev -E libpng -E zlib.dev -E libjpeg -E gcc -E glibcLocales
#

{ pkgs ? import <nixpkgs> {}
}:

let

  inherit (pkgs) makeWrapper;
  inherit (pkgs.stdenv.lib) fix' extends inNixShell;

  pythonPackages =
  import "${toString pkgs.path}/pkgs/top-level/python-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv;
    python = pkgs.python36;
    # patching pip so it does not try to remove files when running nix-shell
    overrides =
      self: super: {
        bootstrapped-pip = super.bootstrapped-pip.overrideDerivation (old: {
          patchPhase = old.patchPhase + ''
            sed -i               -e "s|paths_to_remove.remove(auto_confirm)|#paths_to_remove.remove(auto_confirm)|"                -e "s|self.uninstalled = paths_to_remove|#self.uninstalled = paths_to_remove|"                  $out/${pkgs.python35.sitePackages}/pip/req/req_install.py
          '';
        });
      };
  };

  commonBuildInputs = with pkgs; [ gfortran blas pkgconfig freetype.dev libpng zlib.dev libjpeg gcc glibcLocales ];
  commonDoCheck = false;

  withPackages = pkgs':
    let
      pkgs = builtins.removeAttrs pkgs' ["__unfix__"];
      interpreter = pythonPackages.buildPythonPackage {
        name = "python36-interpreter";
        buildInputs = [ makeWrapper ] ++ (builtins.attrValues pkgs);
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${pythonPackages.python.interpreter}               $out/bin/${pythonPackages.python.executable}
          for dep in ${builtins.concatStringsSep " "               (builtins.attrValues pkgs)}; do
            if [ -d "$dep/bin" ]; then
              for prog in "$dep/bin/"*; do
                if [ -f $prog ]; then
                  ln -s $prog $out/bin/`basename $prog`
                fi
              done
            fi
          done
          for prog in "$out/bin/"*; do
            wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
          done
          pushd $out/bin
          ln -s ${pythonPackages.python.executable} python
          ln -s ${pythonPackages.python.executable}               python3
          popd
        '';
        passthru.interpreter = pythonPackages.python;
      };
    in {
      __old = pythonPackages;
      inherit interpreter;
      mkDerivation = pythonPackages.buildPythonPackage;
      packages = pkgs;
      overrideDerivation = drv: f:
        pythonPackages.buildPythonPackage (drv.drvAttrs // f drv.drvAttrs //                                            { meta = drv.meta; });
      withPackages = pkgs'':
        withPackages (pkgs // pkgs'');
    };

  python = withPackages {};

  generated = self: {

    "EZGmail" = python.mkDerivation {
      name = "EZGmail-0.0.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/d4/21/52c303c69cafc01c7813204018fea0fe08012dd0151348233120a5dd5193/EZGmail-0.0.4.tar.gz"; sha256 = "18df667c47abc99a17da0da02e820e2a8850192983090539916731c459b79056"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."google-api-python-client"
      self."oauth2client"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/asweigart/ezgmail";
        license = licenses.gpl3Plus;
        description = "A Pythonic interface to the Gmail API that actually works as of Dec 2018.";
      };
    };



    "cachetools" = python.mkDerivation {
      name = "cachetools-3.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e6/28/7cde8e73835ff48b4f35b2d93a509575f7bc02b7d614ada71b820c8d9233/cachetools-3.0.0.tar.gz"; sha256 = "4621965b0d9d4c82a79a29edbad19946f5e7702df4afae7d1ed2df951559a8cc"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/tkem/cachetools";
        license = licenses.mit;
        description = "Extensible memoizing collections and decorators";
      };
    };



    "google-api-python-client" = python.mkDerivation {
      name = "google-api-python-client-1.7.7";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e0/91/0e6a42ea3e0898a75d819a9690c8c8d0eecd31275d8a85503c8fc33949f2/google-api-python-client-1.7.7.tar.gz"; sha256 = "9106e7d09d80f59a9472a91edd85c2d6ad420aef28c9440ce1691b4a19ba9ada"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."google-auth"
      self."google-auth-httplib2"
      self."httplib2"
      self."six"
      self."uritemplate"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/google/google-api-python-client/";
        license = licenses.asl20;
        description = "Google API Client Library for Python";
      };
    };



    "google-auth" = python.mkDerivation {
      name = "google-auth-1.6.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/5f/8a/b75ec006bf703c96920ce9ba3e97ac9c6eb48772af689576808fc68ac04f/google-auth-1.6.2.tar.gz"; sha256 = "e8d64e9bc8cb6f0fc5360c693f86dc9ee6964081ee702e3b5ddc937f99efc950"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."cachetools"
      self."pyasn1-modules"
      self."rsa"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python";
        license = licenses.asl20;
        description = "Google Authentication Library";
      };
    };



    "google-auth-httplib2" = python.mkDerivation {
      name = "google-auth-httplib2-0.0.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e7/32/ac7f30b742276b4911a1439c5291abab1b797ccfd30bc923c5ad67892b13/google-auth-httplib2-0.0.3.tar.gz"; sha256 = "098fade613c25b4527b2c08fa42d11f3c2037dda8995d86de0745228e965d445"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."google-auth"
      self."httplib2"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-httplib2";
        license = licenses.asl20;
        description = "Google Authentication Library: httplib2 transport";
      };
    };



    "httplib2" = python.mkDerivation {
      name = "httplib2-0.12.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ce/ed/803905d670b52fa0edfdd135337e545b4496c2ab3a222f1449b7256eb99f/httplib2-0.12.0.tar.gz"; sha256 = "f61fb838a94ce3b349aa32c92fd8430f7e3511afdb18bf9640d647e30c90a6d6"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/httplib2/httplib2";
        license = licenses.mit;
        description = "A comprehensive HTTP client library.";
      };
    };



    "oauth2client" = python.mkDerivation {
      name = "oauth2client-4.1.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"; sha256 = "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."httplib2"
      self."pyasn1"
      self."pyasn1-modules"
      self."rsa"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/google/oauth2client/";
        license = licenses.asl20;
        description = "OAuth 2.0 client library";
      };
    };



    "pyasn1" = python.mkDerivation {
      name = "pyasn1-0.4.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/46/60/b7e32f6ff481b8a1f6c8f02b0fd9b693d1c92ddd2efb038ec050d99a7245/pyasn1-0.4.5.tar.gz"; sha256 = "da2420fe13a9452d8ae97a0e478adde1dee153b11ba832a95b223a2ba01c10f7"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/etingof/pyasn1";
        license = licenses.bsdOriginal;
        description = "ASN.1 types and codecs";
      };
    };



    "pyasn1-modules" = python.mkDerivation {
      name = "pyasn1-modules-0.2.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/c8/0e/3fe59edc782faf8b429f4a1db734418d0f68a7e50f43095747c08330e952/pyasn1-modules-0.2.3.tar.gz"; sha256 = "d14fcb29dabecba3d7b360bf72327c26c385248a5d603cf6be5f566ce999b261"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."pyasn1"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/etingof/pyasn1-modules";
        license = licenses.bsdOriginal;
        description = "A collection of ASN.1-based protocols modules.";
      };
    };



    "rsa" = python.mkDerivation {
      name = "rsa-4.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/cb/d0/8f99b91432a60ca4b1cd478fd0bdf28c1901c58e3a9f14f4ba3dba86b57f/rsa-4.0.tar.gz"; sha256 = "1a836406405730121ae9823e19c6e806c62bbad73f890574fff50efa4122c487"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."pyasn1"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://stuvel.eu/rsa";
        license = "License :: OSI Approved :: Apache Software License";
        description = "Pure-Python RSA implementation";
      };
    };



    "six" = python.mkDerivation {
      name = "six-1.12.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"; sha256 = "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/benjaminp/six";
        license = licenses.mit;
        description = "Python 2 and 3 compatibility utilities";
      };
    };



    "uritemplate" = python.mkDerivation {
      name = "uritemplate-3.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/cd/db/f7b98cdc3f81513fb25d3cbe2501d621882ee81150b745cdd1363278c10a/uritemplate-3.0.0.tar.gz"; sha256 = "c02643cebe23fc8adb5e6becffe201185bf06c40bda5c0b4028a93f1527d011d"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://uritemplate.readthedocs.org";
        license = licenses.bsdOriginal;
        description = "URI templates";
      };
    };

  };
  localOverridesFile = ./requirements_override.nix;
  overrides = import localOverridesFile { inherit pkgs python; };
  commonOverrides = [

  ];
  allOverrides =
    (if (builtins.pathExists localOverridesFile)
     then [overrides] else [] ) ++ commonOverrides;

in python.withPackages
   (fix' (pkgs.lib.fold
            extends
            generated
            allOverrides
         )
   )