{
  description = "A basic flake";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      lib = nixpkgs.lib // (import ./lib);
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
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
          meta = lib.f.getPackageMeta package;
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

      mkOverlayPartForPackageType =
        final: prev: packageType: packages:
        if packageType == lib.f.packageTypes.standalone then
          builtins.listToAttrs
            (builtins.map ({ name, meta, package }: { inherit name; value = lib.f.callPackage final package; }) packages)
        else if packageType == lib.f.packageTypes.vimPlugin then
          {
            vimPlugins = prev.vimPlugins //
              mkOverlayPartForPackageType final prev lib.f.packageTypes.standalone packages;
          }
        else
          builtins.trace "TODO: Implement overlay construction for package type '${packageType}'" { }
      ;
      mkOverlay = packages: final: prev:
        builtins.foldl' (a: b: a // b)
          { }
          (builtins.attrValues (builtins.mapAttrs (mkOverlayPartForPackageType final prev)
            (builtins.groupBy ({ name, meta, package }: meta.type)
              (builtins.attrValues (builtins.mapAttrs (name: package: { inherit name package; meta = lib.f.getPackageMeta package; }) packages)))));
    in
    {
      inherit lib;
      packages = constructPackagesOutput (import ./pkgs/all-packages.nix);
      overlays.default = mkOverlay (import ./pkgs/all-packages.nix);
    };
}
