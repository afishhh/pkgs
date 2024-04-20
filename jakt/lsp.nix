{ pkgs
, lib
, stdenv
, esbuild
, nodePackages
, nodejs-18_x
}:

let
  # NOTE: This isn't done by copying * instead *.nix in node2nixOutput because of nix bug #7150
  # addNodePackagesToSrc = src: node-packages: stdenv.mkDerivation {
  #   name = "rar-node-packages-and-src";
  #
  #   builder = pkgs.writeScript "builder.sh" ''
  #     source $stdenv/setup
  #
  #     mkdir -p $out
  #     cp -r ${node-packages}/* $out
  #     cp -r ${src}/* $out
  #   '';
  # };
  # post install downloads some vscode extensions we don't want
  rootNodePackages = (pkgs.callPackage ./vscode-node2nix/root/default.nix { }).nodeDependencies;
  serverNodePackages = (pkgs.callPackage ./vscode-node2nix/server/default.nix { }).nodeDependencies;
in
lib.f.mkPackage stdenv.mkDerivation {
  pname = "jakt-language-server";
  version = "unstable-2023-04-20";

  nativeBuildInputs = [ esbuild ];

  src = (import ./src.nix).jakt + /editors/vscode;

  unpackPhase = "";

  buildPhase = ''
    ln -s ${rootNodePackages}/lib/node_modules node_modules
    ln -s ${serverNodePackages}/lib/node_modules server/node_modules

    esbuild server/src/server.ts --bundle --outdir=out --external:vscode --platform=node
  '';

  installPhase = ''
    mkdir -p $out/bin
    echo "#!${nodejs-18_x}/bin/node" > $out/bin/jakt-language-server
    cat out/server.js >>$out/bin/jakt-language-server
    chmod +x $out/bin/jakt-language-server
  '';

  meta = {
    description = "Language server for the Jakt programming language.";
    homepage = "https://github.com/SerenityOS/jakt";
    license = lib.licenses.bsd2;
    systems = lib.f.defaultSystems;
  };
}
