let
  package = import ./package.nix { inherit lib; };
  systems = import ./systems.nix { inherit lib; };
  lib = {
    f = package // systems;
  };
in
lib
