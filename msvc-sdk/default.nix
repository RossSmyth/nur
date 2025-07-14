{
  stdenv,
  runCommand,
  xwin,
}:
assert stdenv.hostPlatform.isx86_64;
runCommand "msvc-sdk"
  {
    buildInputs = [ xwin ];

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-bMS9gZ43tziL1t4ph84TYfDM8SLhRXtBibBqRLV/6Xc=";

    manifest = ./manifest.json;
  }
  ''
    xwin --accept-license --cache-dir=xwin-out --manifest=$manifest splat --preserve-ms-arch-notation --use-winsysroot-style
    mkdir $out/
    mv xwin-out/splat/* $out/

    pushd $out/Windows\ Kits/10/
    mv include Include
    mv lib Lib
    popd
  ''
