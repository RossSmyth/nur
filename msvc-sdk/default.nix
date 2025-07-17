{
  lib,
  runCommand,
  xwin,
}:
let
  version = (builtins.fromJSON (builtins.readFile ./manifest.json)).info.productSemanticVersion;
in
runCommand "msvc-sdk-${version}"
  {
    inherit version;
    buildInputs = [ xwin ];

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-2MfUJDwScir/V9+aCu94RYPexSEKGemn92ZNclfYNIw=";

    manifest = ./manifest.json;

    meta = {
      description = "MSVC SDK and Windows CRT for cross compiling on Linux";
      homepage = "https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/";
      license = lib.licenses.unfreeRedistributable;
      maintainers = [ lib.maintainers.RossSmyth ];
      platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86_64;
    };
  }
  ''
    xwin --accept-license --cache-dir=xwin-out --manifest="$manifest" splat --preserve-ms-arch-notation --use-winsysroot-style
    mkdir "$out"
    mv xwin-out/splat/* "$out"

    ls -al "$out"
    echo "Fixing directory names..."
    pushd "$out/Windows Kits/10/"
    mv include Include
    mv lib Lib
    popd
    echo "Fixed"
  ''
