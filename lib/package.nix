{ lib }:

let
  mkPackage = constructor: { meta, ... }@attrs: {
    type = "f.package";
    inherit constructor meta;
    final = constructor attrs;
  };
  coercePackage = thing:
    if builtins.isPath thing then
      import thing
    else if builtins.isFunction thing then
      thing
    else
      builtins.abort "${thing} cannot be coerced into a package type (path or function)";
  getPackageMeta = package:
    let function = coercePackage package;
    in
    (function (builtins.mapAttrs
      (name: value:
        if name == "lib" then lib
        else if name == "pkgs" then { inherit lib; }
        else null
      )
      (builtins.functionArgs function))).meta
  ;
  isPackage = package: builtins.isAttrs package && package?type && package.type == "f.package";
  callPackage = pkgs: package: (pkgs.callPackage (coercePackage package) { }).final;
in
{
  inherit mkPackage getPackageMeta isPackage callPackage;
}
