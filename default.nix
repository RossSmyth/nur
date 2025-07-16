{
  pkgs ? import <nixpkgs> {
    overlays = [
      (import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
      (import (
        builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/snapshot/2024-08-01.tar.gz"
      ))
    ];
  },
}:
let
  inherit (pkgs) callPackage;
in
pkgs.lib.fix (self: {
  c2rust = callPackage ./c2rust { };

  cerberus = callPackage ./cerberus { };

  clang-cl = callPackage ./clang-cl {
    inherit (self) msvcSdk;
  };

  isle-portable = callPackage ./isle-portable { };

  jqjq = callPackage ./jqjq { };

  msvcRust = callPackage ./msvc-rust {
    inherit (self) clang-cl msvcSdk;
    rustc =
      pkgs.rust-bin.stable.latest.minimal.override
        or (throw "requires rust-overlay to get windows-msvc std")
        { targets = [ "x86_64-pc-windows-msvc" ]; };
  };

  msvcSdk = callPackage ./msvc-sdk { inherit (self) xwin; };

  wuffs = callPackage ./wuffs { };

  xwin = callPackage ./xwin { };
})
