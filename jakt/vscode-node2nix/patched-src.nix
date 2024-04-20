{ stdenv, ... }:

stdenv.mkDerivation {
  name = "patched-jakt-lsp-root";

  src = (import ../src.nix).jakt;

  patches = [ ./jakt-vscode-no-postinstall.patch ];

  unpackPhase = "";

  installPhase = ''
    source $stdenv/setup;

    cp -r editors/vscode $out
  '';
}
