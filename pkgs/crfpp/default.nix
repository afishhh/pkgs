{ stdenv
, fetchzip
, lib
}:

lib.f.mkPackage stdenv.mkDerivation {
  pname = "crfpp";
  version = "0.58";

  src = fetchzip {
    # Original google drive file returns 404
    # Retrieved from https://archive.netbsd.org/pub/pkgsrc-archive/distfiles/2019Q4/
    # Extracted nix hash matches original perfectly
    url = "https://fishhh.dev/files/CRF++-0.58.tar.gz";
    hash = "sha256-rnyIWPUV2sdQTmcPGgPuAj5MBk2T4jJp2zBfDU8ElPI=";
  };

  meta = {
    description = "Yet Another CRF toolkit";
    homepage = "https://taku910.github.io/crfpp/";
    license = with lib.licenses; [ lgpl2Only bsd2 ];
    systems = lib.f.defaultSystems;
  };
}
