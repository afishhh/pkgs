{ lib
, stdenv
, python3
}:

{ name ? "source"
, file_id
, hash
, extension ? null
, ...
}@attrs:

stdenv.mkDerivation ({
  inherit name;

  phases = [ "downloadPhase" "unpackPhase" "installPhase" ];

  nativeBuildInputs = [
    python3
    python3.pkgs.requests
  ];

  downloadPhase = ''
    src=$(python3 ${./google_drive_download.py} ${lib.escapeShellArg file_id})
  '' + lib.optionalString (extension != null) ''mv $src source.${extension}; src=source.${extension}'';

  installPhase = ''
    cp -r . $out
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = hash;
} // (builtins.removeAttrs attrs [ "name" "file_id" "hash" "extension" ]))
