{
  lib,
  stdenv,
  rustPlatform,
  fetchFromCodeberg,
  cmake,
  ninja,
  pkg-config,
  wayland,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "microcad";
  version = "0.5.0";

  src = fetchFromCodeberg {
    owner = "microcad";
    repo = "microcad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2164ynL01cLv5/D1FkcZpuBXTHPMjbpeaPPEZpmrSso=";
  };

  cargoHash = "sha256-OwPAl8LirPQEQ8ytx/+9OnrdbUagLA25mGMw1z/L6V0=";
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    wayland
  ];

  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontUseNinjaCheck = true;

  cargoBuildFlags = [
    "-p"
    "microcad"
    "-p"
    "microcad-lsp"
    "-p"
    "microcad-viewer"
  ];
})
