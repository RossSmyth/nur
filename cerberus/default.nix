{
  lib,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  unstableGitUpdater,
  ocamlPackages,
  opam,
}:
ocamlPackages.buildDunePackage {
  pname = "cerberus";
  version = "0-unstable-2025-06-29";

  src = fetchFromGitHub {
    owner = "rems-project";
    repo = "cerberus";
    rev = "61700b301f0f1fbc1940db51c50240c397759057";
    hash = "sha256-QpgHOQqiJMlMf2RH5/TI3AirdqYPS7HwE9YIlxgorqg=";
  };

  minimalOCamlVersion = "4.12";

  strictDeps = true;

  nativeBuildInputs = [
    opam
    writableTmpDirAsHomeHook
    ocamlPackages.lem
    ocamlPackages.menhir
  ];

  buildInputs = with ocamlPackages; [
    sha
    pprint
    # px_sexp_conv
    cmdliner
    yojson
    lem
    menhir
    result
    ppx_deriving
    zarith
    sexplib
    menhirLib
    janeStreet.ppx_sexp_conv
  ];

  env.OPAM_SWITCH_PREFIX = placeholder "out";
  buildPhase = ''
    runHook preBuild

    make Q= cerberus

    runHook postBuild
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    PATH="$out/bin":$PATH

    patchShebangs --build tests

    exec tests/run-ci.sh
  '';

  passthru.updateScript = unstableGitUpdater { branch = "master"; };

  meta = {
    description = "formal operational semantics machine for ISO C11";
    homepage = "https://www.cl.cam.ac.uk/~pes20/cerberus/";
    license = with lib.licenses; [
      # Most of Cerberus
      bsd2
      # https://github.com/rems-project/cerberus/blob/master/THIRD_PARTY_FILES.md
      # Files from Linux kernel
      gpl2Only
      # Files from cppmem
      bsd3
      # Files from musl
      mit
      # Files from BSD
      bsdOriginal
      # Slightly modified vendored SibylFS
      isc
    ];
    mainProgram = "cerberus";
    maintainers = with lib.maintainers; [
      RossSmyth
    ];
    platforms = lib.platforms.unix;
  };
}
