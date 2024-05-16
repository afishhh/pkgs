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
      fetchers = builtins.mapAttrs (system: pkgs: builtins.mapAttrs (name: value: lib.f.callPackageWith pkgs value) (import ./pkgs/fetchers/all.nix)) evaluatedNixpkgs;

      constructPackagesFor = output: name: package:
        let
          meta = lib.f.getPackageMeta package;
          inherit (meta) systems;
        in
        builtins.foldl'
          (attrs: system: attrs // {
            ${system}.${name} = lib.f.callPackageWith (evaluatedNixpkgs.${system} // fetchers.${system} // output.${system}) package;
          })
          { }
          systems;
      constructPackagesOutput =
        packages:
        let
          result = builtins.foldl'
            (lib.recursiveUpdateUntil
              (path: lhs: rhs: lib.f.isPackage lhs || lib.f.isPackage rhs)
            )
            { }
            (builtins.attrValues (builtins.mapAttrs (constructPackagesFor result) packages));
        in
        result
      ;

      mkOverlayPartForPackageType =
        final: prev: packageType: packages:
        if packageType == lib.f.packageTypes.standalone then
          builtins.listToAttrs
            (builtins.map ({ name, meta, package }: { inherit name; value = lib.f.callPackageWith (final // fetchers.${final.system}) package; }) packages)
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

      allModules = import ./modules/all-modules.nix;
    in
    {
      inherit lib;
      packages = constructPackagesOutput (import ./pkgs/all-packages.nix);
      overlays.default = mkOverlay (import ./pkgs/all-packages.nix);
      nixosModules = allModules // {
        default = _: {
          imports = builtins.attrValues allModules;
        };
      };
    };
}
