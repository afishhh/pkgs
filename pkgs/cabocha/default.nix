{ stdenv
, lib
, fetchzip
, libiconv
, crfpp
, mecab
}:

lib.f.mkPackage stdenv.mkDerivation {
  pname = "cabocha";
  version = "0.69";

  nativeBuildInputs = [ libiconv ];
  buildInputs = [ crfpp mecab ];

  src = fetchzip {
    # Same situation as CRF++
    url = "https://fishhh.dev/files/cabocha-0.69.tar.gz";
    hash = "sha256-gCSeFh+QiD7ptrso3B47L4Yn5tzjwXgk3ZKmeh67ti8=";
  };

  CABOCHA_DEFAULT_RC = "${placeholder "out"}/etc/cabocharc";
  makeFlags = [ "CXXFLAGS=-std=c++14" ];

  configureFlags = [
    "--with-charset=utf8"
  ];

  meta = {
    description = "Yet Another Japanese Dependency Structure Analyzer";
    homepage = "https://taku910.github.io/cabocha/";
    license = with lib.licenses; [ lgpl2Only bsd2 ];
    systems = lib.f.defaultSystems;
  };
}
