{ lib
, buildNpmPackage
, fetchNpmDeps
, importNpmLock
, cmake
, ninja
, python3
, nodejs
, kuzuSrc
}:

buildNpmPackage {
  pname = "kuzu";
  version = "0.8.2";
  src = kuzuSrc;

  # TODO: add patch that removes the npx commands to get CMAKE_JS_LIB etc. 
  #sourceDir = "tools/nodejs_api";
  buildInputs = [
    nodejs
  ];
  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  npmInstallFlags = [ "--include=dev" ];
  # npmDeps = fetchNpmDeps {
  #   src = lib.cleanSource (kuzuSrc + "/tools/nodejs_api");
  #   hash = "sha256-a/MptSuwHiH7tu02aE8cK5AAkSzVzN27GNQ6gSCWoCo=";
  # };
  npmDeps = importNpmLock {
    npmRoot = kuzuSrc + "/tools/nodejs_api";
  };
  npmConfigHook = importNpmLock.npmConfigHook;

  # TODO: some patching is required for this to build correctly.
  # Also it might be better to build the nodejs bindings in the toplevel project...
  patches = [];

  postPatch = ''
    echo "Running postPatch"
    cd tools/nodejs_api
    runHook npmConfigHook
  '';

  # The npm install needs to occur in the nodesj_api folder, before the CMake build;
  # cmakeConfigurePhase will execute pre/post hooks, but the build must happen at the repository root.
  cmakeFlags = [ "-DBUILD_NODEJS=TRUE" "-DBUILD_SHELL=FALSE" ];
  configurePhase = ''
    cd ../..
    postConfigureHooks=()
    cmakeConfigurePhase
    echo Exiting configurePhase
  '';

  # Override since it doesn't pass cmake flags correctly
  buildPhase = "ninjaBuildPhase";
}
