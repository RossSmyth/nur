{ pkgs }:
let
  inherit (pkgs) callPackage;
in
{
  jqjq = callPackage ./jqjq { };
  isle-portable = callPackage ./isle-portable { };
}
