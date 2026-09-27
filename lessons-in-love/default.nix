{
  lib,
  stdenvNoCC,
  fetchItchIo,
  renpyMinimal,
  writableTmpDirAsHomeHook,
  _7zz,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lessons-in-love";
  version = "0.61.0";

  src = fetchItchIo {
    name = "lessons-in-love-windows.zip";
    gameUrl = "https://djnostyle.itch.io/lessons-in-love";
    upload = "6262900";
    hash = "sha256-Thw+wRWnt/c7275GmiYjBNlv0t0gZGbFUhxPRbakQDw=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    _7zz # Much faster than unzip
    writableTmpDirAsHomeHook
    makeWrapper
    renpyMinimal
    copyDesktopItems
  ];

  # The hook only unpack dmg files.
  unpackCmd = ''7zz x -sns- -snld "$curSrc"'';

  buildPhase = ''
    runHook preBuild

    renpy . compile
    rm -r game/saves

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    INSTALL_DIR="$out/share/lessons-in-love"

    mkdir -p "$INSTALL_DIR"

    cp -r game "$INSTALL_DIR"

    find "$INSTALL_DIR" -type f -name "*.rpy" -delete

    makeWrapper ${lib.getExe renpyMinimal} "$out/bin/lessons-in-love" \
      --add-flags "$INSTALL_DIR" --add-flags run

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "lessons-in-love";
      desktopName = "Lessons In Love";
      type = "Application";
      categories = [ "Game" ];
      exec = "lessons-in-love";
    })
  ];

  meta.mainProgram = "lessons-in-love";
})
