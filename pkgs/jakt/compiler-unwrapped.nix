{ pkg-config
, cmake
, llvmPackages_16
, ninja
}:

llvmPackages_16.stdenv.mkDerivation {
  pname = "jakt-unwrapped";
  version = "unstable-2024-04-20";

  nativeBuildInputs = [ pkg-config cmake ninja ];

  src = (import ./src.nix).jakt;

  cmakeFlags = [
    "-DSERENITY_SOURCE_DIR=${(import ./src.nix).serenity}"
    "-DCMAKE_INSTALL_BINDIR=bin"
  ];
}
