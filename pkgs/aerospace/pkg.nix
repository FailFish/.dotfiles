{
  fetchzip,
  installShellFiles,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "aerospace";
  version = "0.20.2-Beta";
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
    hash = "sha256-PyWHtM38XPNkkEZ0kACPia0doR46FRpmSoNdsOhU4uw=";
  };
}
