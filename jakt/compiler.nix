{ pkgs
, stdenv
, lib
, llvmPackages_16
, makeWrapper
, ...
}:

let
  unwrapped = pkgs.callPackage ./compiler-unwrapped.nix { };
in
lib.f.mkPackage stdenv.mkDerivation {
  pname = "jakt";
  inherit (unwrapped) version;

  nativeBuildInputs = [ makeWrapper ];

  builder = pkgs.writeScript "builder.sh" ''
    source $stdenv/setup

    mkdir -p $out/bin
    makeWrapper $unwrapped/bin/jakt_stage1 $out/bin/jakt --suffix PATH : "${ lib.makeBinPath [ llvmPackages_16.clang ] }"
    ln -s $unwrapped/include $out/include

    mkdir -p $out/lib/cmake

    for file in "$unwrapped/lib/"*; do
      ln -s "$file" "$out/lib/$(basename "$file")"
    done

    ln -s "$unwrapped/share/Jakt" "$out/lib/cmake/Jakt"
  '';

  inherit unwrapped;

  meta = {
    description = "Reference compiler implementation for the Jakt programming language.";
    homepage = "https://github.com/SerenityOS/jakt";
    license = lib.licenses.bsd2;
    systems = lib.f.defaultSystems;
  };
}
