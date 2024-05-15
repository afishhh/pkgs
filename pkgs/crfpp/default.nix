{ stdenv
, fetchgdrive
, lib
}:

lib.f.mkPackage stdenv.mkDerivation {
  pname = "crfpp";
  version = "0.58";

  src = fetchgdrive {
    file_id = "0B4y35FiV1wh7QVR6VXJ5dWExSTQ";
    extension = "tar.gz";
    hash = "sha256-rnyIWPUV2sdQTmcPGgPuAj5MBk2T4jJp2zBfDU8ElPI=";
  };

  meta = {
    description = "Yet Another CRF toolkit";
    homepage = "https://taku910.github.io/crfpp/";
    license = with lib.licenses; [ lgpl2Only bsd2 ];
    systems = lib.f.defaultSystems;
  };
}
