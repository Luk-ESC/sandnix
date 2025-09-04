{
  lib,
  stdenvNoCC,
  gnutar,
  bash,
  jdk23,
  libGL,
  unzip,
  requireFile,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  file = requireFile {
    name = "Sandtrix_3.0_LINUX.tar.gz";
    hash = "sha256-uxZxeQrg9UQ1EHHuz+/GUJyHMhJMVRYnjlE7+RSnsTM=";
    url = "https://mslivo.itch.io/sandtrix?download";
  };

  libs = lib.makeLibraryPath [
    libGL
  ];

  env = "LD_LIBRARY_PATH=${libs}";
  cmd = "${lib.getExe jdk23} -jar $out/lib/sandtrix.jar";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  name = "sandtrix";
  version = "3.0.0";

  src = file;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  desktopItem = [
    (makeDesktopItem {
      name = "sandtrix";
      desktopName = "Sandtrix";
      icon = "Sandtrix";
      exec = "sandtrix";
    })
  ];

  unpackPhase = ''
    runHook preUnpack

    ${lib.getExe gnutar} xvf $src
    ${lib.getExe unzip} -j sandtrix-1.0-SNAPSHOT-jar-with-dependencies.jar sprites/appicon.png

    mkdir -p $out/lib
    mkdir -p $out/share/icons/hicolor/32x32/apps
    mv appicon.png $out/share/icons/hicolor/32x32/apps/Sandtrix.png
    mv sandtrix-1.0-SNAPSHOT-jar-with-dependencies.jar $out/lib/sandtrix.jar

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

     mkdir -p $out/bin

     echo "#! ${lib.getExe bash}" > $out/bin/sandtrix
     echo "${env} ${cmd}" >> $out/bin/sandtrix
     chmod +x $out/bin/sandtrix

    runHook postInstall
  '';
})
