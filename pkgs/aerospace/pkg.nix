{
  fetchzip,
  installShellFiles,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "aerospace";
  version = "0.14.2-Beta";
  nativeBuildInputs = [ installShellFiles ];
  buildPhase = "";
  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv AeroSpace.app $out/Applications
    cp -R bin $out

    runHook postInstall
  '';

  postInstall = ''
    installManPage manpage/*
    installShellCompletion --bash shell-completion/bash/aerospace
    installShellCompletion --fish shell-completion/fish/aerospace.fish
    installShellCompletion --zsh  shell-completion/zsh/_aerospace
  '';

  src = fetchzip {
    url =
      "https://github.com/nikitabobko/AeroSpace/releases/download/v${version}/AeroSpace-v${version}.zip";
    hash = "sha256-v2D/IV9Va0zbGHEwSGt6jvDqQYqha290Lm6u+nZTS3A=";
  };
}
