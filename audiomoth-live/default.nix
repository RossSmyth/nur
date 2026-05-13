{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
  iconConvTools,
  makeDesktopItem,
  copyDesktopItems,
}:
buildNpmPackage (finalAttrs: {
  pname = "audiomoth-live";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "OpenAcousticDevices";
    repo = "AudioMoth-Live-App";
    tag = finalAttrs.version;
    hash = "sha256-CHQryfBKzdY/UlfnNzBu6EjtMErQyTmTFC5GeltF3fg=";
  };

  postPatch = ''
    # Fix path for simulated data
    substituteInPlace "js/index.js" \
      --replace-fail "app.isPackaged ? path.join(process.resourcesPath, 'simulator') : path.join('.', 'simulator');" "'$out/share/audiomoth-live/resources/simulator'"
    cp ${./package-lock.json} package-lock.json
  '';

  __structuredAttrs = true;
  npmDepsHash = "sha256-QIrzyIj49gWNttpQjwnbJUxUcekSfflK+DdK/wrOpjw=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    iconConvTools
    copyDesktopItems
  ];

  buildPhase = ''
    runHook preBuild

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm_config_nodedir=${electron.headers} npm exec electron-builder -- \
      --dir \
      --publish never \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.mac.identity=null \
      -c.compression=maximum

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    icoFileToHiColorTheme build/icon.ico audiomoth-live "$out"

    mkdir -p "$out/share/audiomoth-live/resources"
    cp dist/linux-unpacked/resources/app.asar "$out/share/audiomoth-live/resources"

    makeWrapper ${lib.getExe electron} "$out/bin/audiomoth-live" \
      --add-flags "$out/share/audiomoth-live/resources/app.asar" \
      --set-default "ELECTRON_FORCE_IS_PACKAGED" "1"

    cp -r simulator "$out/share/audiomoth-live/resources"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "AudioMoth-live";
      desktopName = "AudioMoth-live";
      exec = "audiomoth-live";
      icon = "audiomoth-live";
      terminal = false;
      type = "Application";
      comment = finalAttrs.meta.description;
      categories = [
        "AudioVideo"
        "Audio"
        "Science"
        "Electronics"
        "Recorder"
        "Education"
      ];
      keywords = [
        "audiomoth"
        "microphone"
      ];
    })
  ];

  meta = {
    description = "for recording and analysing live audio from the AudioMoth USB Microphone";
    mainProgram = "audiomoth-live";
    homepage = "https://www.openacousticdevices.info/live";
    downloadPage = "https://github.com/OpenAcousticDevices/AudioMoth-Live-App/releases";
    changelog = "https://github.com/OpenAcousticDevices/AudioMoth-Live-App/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.RossSmyth ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
  };
})
