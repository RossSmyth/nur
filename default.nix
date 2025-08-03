{
  pkgs ? import <nixpkgs> {
    config.microsoftVisualStudioLicenseAccepted = true;
    overlays = [
      (import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
    ];
  },
}:
pkgs.lib.makeScope pkgs.newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    c2rust =
      let
        # c2rust requires an old (2022) nightly
        old-rust = pkgs.extend (
          import (
            builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/snapshot/2024-08-01.tar.gz"
          )
        );
      in
      old-rust.callPackage ./c2rust { };

    clang-cl = callPackage ./clang-cl { };

    isle-portable = callPackage ./isle-portable { };

    jqjq = callPackage ./jqjq { };

    msvcRust = callPackage ./msvc-rust {
      rustc =
        pkgs.rust-bin.stable.latest.minimal.override
          or (throw "requires rust-overlay to get windows-msvc std")
          { targets = [ "x86_64-pc-windows-msvc" ]; };
    };

    wuffs = callPackage ./wuffs { };
  }
)
