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
  pkgs,
}:
let
  file = requireFile {
    name = "Sandtrix_3.0_LINUX.tar.gz";
    hash = "sha256-uxZxeQrg9UQ1EHHuz+/GUJyHMhJMVRYnjlE7+RSnsTM=";
    url = "https://mslivo.itch.io/sandtrix?download";
  };

  raw = pkgs.runCommand "sandtrix-raw" { } ''
    ${lib.getExe gnutar} xvf ${file}
    ${lib.getExe unzip} -j sandtrix-1.0-SNAPSHOT-jar-with-dependencies.jar sprites/appicon.png

    mkdir -p $out/
    mv appicon.png $out/sandtrix.png
    mv sandtrix-1.0-SNAPSHOT-jar-with-dependencies.jar $out/sandtrix.jar
  '';

  libs = lib.makeLibraryPath [
    libGL
  ];

  env = "LD_LIBRARY_PATH=${libs}";
  cmd = "${lib.getExe jdk23} -jar ${raw}/sandtrix.jar";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  name = "sandtrix";
  version = "3.0.0";

  nativeBuildInputs = [
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "sandtrix";
      desktopName = "Sandtrix";
      icon = "${raw}/sandtrix.png";
      exec = "env ${env} ${cmd}";
    })
  ];

  unpackPhase = ''
    runHook preUnpack

    mkdir -p $out/share/pixmaps
    cp ${raw}/sandtrix.png $out/share/pixmaps

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
