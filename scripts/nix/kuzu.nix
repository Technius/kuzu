{ stdenv, lib, cmake, ninja, python3, kuzuSrc }:

stdenv.mkDerivation (finalAttrs: {
  pname = "kuzu";
  version = "0.8.2";
  src = kuzuSrc;

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  meta = {
    description = "An embeddable, scalable, extremely fast graph database";
    license = lib.licenses.mit;
    homepage = "https://kuzudb.com";
    changelog = "https://github.com/kuzudb/kuzu/releases/tag/v${finalAttrs.version}";
    mainProgram = "kuzu";
  };
})
