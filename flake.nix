{
  description = "A basic flake";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      lib = nixpkgs.lib // (import ./lib);
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      evaluatedNixpkgs = builtins.listToAttrs
        (builtins.map
          (system: {
            name = system;
            value = import nixpkgs {
              inherit system;
              overlays = [ (final: prev: { inherit lib; }) ];
            };
          })
          supportedSystems
        );

      constructPackagesFor = name: package:
        let
          imported = import package;
          meta = lib.f.getPackageMeta imported;
          inherit (meta) systems;
        in
        builtins.foldl'
          (attrs: system: attrs // {
            ${system}.${name} = lib.f.callPackage evaluatedNixpkgs.${system} package;
          })
          { }
          systems;
      constructPackagesOutput =
        packages:
        builtins.foldl'
          (lib.recursiveUpdateUntil
            (path: lhs: rhs: lib.f.isPackage lhs || lib.f.isPackage rhs)
          )
          { }
          (builtins.attrValues (builtins.mapAttrs constructPackagesFor packages))
      ;
    in
    {
      packages = constructPackagesOutput (import ./all-packages.nix);
    };
}
