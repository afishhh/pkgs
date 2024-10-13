{ stdenv, ... }:

stdenv.mkDerivation {
  name = "patched-jakt-lsp-root";

  src = (import ../src.nix).jakt;

  # post install downloads some vscode extensions we don't want
  patches = [ ./jakt-vscode-no-postinstall.patch ];

  unpackPhase = "";

  installPhase = ''
    source $stdenv/setup;

    cp -r editors/vscode $out
  '';
}
