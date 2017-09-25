# Add packages to buildInputs and simply run with `nix-shell` in current dir
{ system ? builtins.currentSystem }:

let
  pkgs = import ./pkgs/top-level/all-packages.nix {};

in pkgs.stdenv.mkDerivation {
  name = "shell";
  buildInputs = with pkgs; [
  ];
}
