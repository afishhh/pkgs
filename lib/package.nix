{ lib }:

let
  mkPackage = constructor: { meta, passthru ? { }, ... }@attrs: attrs // passthru // {
    inherit (constructor attrs) name outPath outputs;

    type = "derivation";
    meta = meta // {
      inherit constructor;
    } // (
      if meta?type then { } else { type = lib.f.packageTypes.standalone; }
    );
  };
  coercePackage = thing:
    if builtins.isPath thing then
      import thing
    else if builtins.isFunction thing then
      thing
    else
      builtins.abort "${thing} cannot be coerced into a package type (path or function)";

  getPackageMeta = package:
    let
      function = coercePackage package;
      args = builtins.mapAttrs
        (name: value:
          if name == "lib" then lib
          else if name == "pkgs" then { inherit lib; }
          else null
        )
        (builtins.functionArgs function);
    in
    (function args).meta
  ;

  isPackage = package: builtins.isAttrs package && package?type && package.type == "f.package";

  callPackage = pkgs: package:
    (pkgs.callPackage
      (coercePackage package)
      { lib = pkgs.lib // lib; })
  ;
in
{
  inherit mkPackage getPackageMeta isPackage callPackage;
  packageTypes = builtins.listToAttrs (builtins.map (v: { name = v; value = v; }) [
    "standalone"
    "vimPlugin"
  ]);
}
