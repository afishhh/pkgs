{ lib }:

let
  mkMeta = meta: meta
    // (if meta?type then { } else { type = lib.f.packageTypes.standalone; })
    // (if meta?systems then { } else { systems = lib.f.defaultSystems; })
  ;

  mkPackage = constructor: { meta, passthru ? { }, ... }@attrs: attrs // passthru // {
    inherit (constructor attrs) name drvPath outPath outputs;

    type = "derivation";
    meta = (mkMeta meta) // {
      inherit constructor;
    };
  };

  withMeta = package: meta:
    package // { meta = mkMeta (package.meta or { } // meta); };

  getPackageMeta = package:
    let
      function = package;
      pkgs = {
        lib = lib // {
          f = lib.f // {
            withMeta = package: meta: {
              meta = mkMeta meta;
            };
          };
        };
      };
      args = builtins.mapAttrs
        (name: value:
          if name == "pkgs" then pkgs
          else pkgs.${name} or (x: x)
        )
        (builtins.functionArgs function);
    in
    (function args).meta
  ;

  importPackage = thing:
    if builtins.isPath thing then
      importPackage (import thing)
    else if builtins.isFunction thing then
      { __functor = self: thing; meta = getPackageMeta thing; }
    else if isPackage thing then
      thing
    else
      builtins.abort "${thing} could not be imported as a package";


  isPackage = package: package?meta && package.meta?type;

  callPackageWith = pkgs: package:
    (pkgs.lib.callPackageWith pkgs
      (importPackage package)
      { lib = pkgs.lib // lib; })
  ;
in
{
  inherit mkPackage withMeta importPackage isPackage callPackageWith;
  packageTypes = builtins.listToAttrs (builtins.map (v: { name = v; value = v; }) [
    "standalone"
    "vimPlugin"
  ]);
}
