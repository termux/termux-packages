#!/usr/bin/env bash
# Alekas - gera os pacotes base (bootstrap) a partir dos pacotes oficiais do Termux.
# O nome do pacote com.termux vira com.alekas (mesmo tamanho: nenhum arquivo muda de tamanho).
# Os nomes de classe Java continuam com.termux. Licenca: GPLv3.
set -eu

TAG="${1:?uso: alekas-bootstrap.sh <tag-do-termux> <pasta-de-saida>}"
mkdir -p "${2:?uso: alekas-bootstrap.sh <tag-do-termux> <pasta-de-saida>}"
OUT="$(cd "$2" && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
: > "$OUT/SHA256SUMS"

SCRIPTS="bin/termux-wake-unlock bin/termux-wake-lock bin/termux-reset bin/termux-reload-settings bin/termux-open bin/termux-info bin/termux-setup-storage bin/am bin/pkg"
TESTS="libexec/installed-tests/termux-core/app/main/termux-core-tests"

for ARCH in aarch64 arm i686 x86_64; do
  echo "=== $ARCH ==="
  D="$WORK/$ARCH"
  mkdir -p "$D"
  gh release download "$TAG" --repo termux/termux-packages --pattern "bootstrap-$ARCH.zip" --dir "$D"
  unzip -q "$D/bootstrap-$ARCH.zip" -d "$D/tree"
  cd "$D/tree"
  find . -type f -printf '%s %p\n' | sort -k2 > "$D/antes.txt"

  # 1) caminhos: todos os arquivos, menos o am.apk
  find . -type f ! -name '*.apk' -print0 | LC_ALL=C xargs -0 sed -i 's#data/data/com\.termux#data/data/com.alekas#g; s#apps/com\.termux#apps/com.alekas#g'

  # 2) scripts: pacote e acoes trocam, nomes de classe continuam com.termux
  for f in $SCRIPTS; do
    if [ -f "$f" ]; then
      LC_ALL=C sed -i -E 's#com\.termux/com\.termux\.#com.alekas/com.termux.#g; s#"com\.termux"#"com.alekas"#g; s#com\.termux\.(service_[a-z_]+|app\.(reload_style|failsafe_session|notify_app_crash|request_storage_permissions))#com.alekas.\1#g; s#\(com\.termux;#(com.alekas;#g' "$f"
    fi
  done

  # 3) binario de testes
  if [ -f "$TESTS" ]; then
    LC_ALL=C sed -i 's#TERMUX_APP__PACKAGE_NAME="com\.termux"#TERMUX_APP__PACKAGE_NAME="com.alekas"#' "$TESTS"
  fi

  # conferencias (o script para se algo estiver errado)
  find . -type f -printf '%s %p\n' | sort -k2 > "$D/depois.txt"
  if ! diff -q "$D/antes.txt" "$D/depois.txt" > /dev/null; then
    echo "ERRO: tamanho de arquivo mudou em $ARCH"; exit 1
  fi
  LEFT="$(grep -rlaP 'com\.termux(?![./A-Za-z0-9_])' . --exclude='*.apk' | wc -l)"
  if [ "$LEFT" != "0" ]; then
    echo "ERRO: sobraram $LEFT arquivos com com.termux solto em $ARCH"; exit 1
  fi

  # 4) apt do Termux desativado e boas-vindas do Alekas
  printf '%s\n' '# Alekas: o repositorio de pacotes proprio sera adicionado em uma fase futura.' '# Os repositorios do Termux nao sao usados: os pacotes deles sao feitos para com.termux.' > etc/apt/sources.list
  printf '%s\n' '#!/data/data/com.alekas/files/usr/bin/bash' 'echo -e "\e[1mBem-vindo ao Alekas!\e[0m"' 'echo' 'echo "Terminal baseado no Termux (GPLv3)."' 'echo "Projeto: https://github.com/ropazfilho/Alekas"' 'echo "Termux original: https://github.com/termux/termux-app"' 'echo' 'echo "Versao inicial: o comando pkg install ainda nao esta disponivel."' > etc/motd.sh
  printf '%s\n' 'Bem-vindo ao Alekas!' '' 'Terminal baseado no Termux (GPLv3).' 'Projeto: https://github.com/ropazfilho/Alekas' 'Termux original: https://github.com/termux/termux-app' '' 'Versao inicial: o comando pkg install ainda nao esta disponivel.' > etc/motd

  # empacotar e conferir a contagem de itens
  rm -f "$OUT/bootstrap-$ARCH.zip"
  zip -r9 -q "$OUT/bootstrap-$ARCH.zip" ./*
  A="$(unzip -Z1 "$D/bootstrap-$ARCH.zip" | wc -l)"
  B="$(unzip -Z1 "$OUT/bootstrap-$ARCH.zip" | wc -l)"
  if [ "$A" != "$B" ]; then
    echo "ERRO: contagem de itens diferente em $ARCH ($A x $B)"; exit 1
  fi
  ( cd "$OUT" && sha256sum "bootstrap-$ARCH.zip" >> SHA256SUMS )
  echo "ok $ARCH: $B itens"
  cd "$WORK"
done
echo "=== CONCLUIDO ==="
