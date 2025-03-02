{ lib, callPackage }:

let
  kuzuSrc = lib.cleanSource ../..;
in
{
  kuzu = callPackage ./kuzu.nix {
    inherit kuzuSrc;
  };
  kuzu-nodejs = callPackage ./kuzu-nodejs.nix {
    inherit kuzuSrc;
  };
}
