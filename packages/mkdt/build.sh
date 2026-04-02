# Arquitetura OpenSP - Build Script para Termux
TERMUX_PKG_HOMEPAGE=https://github.com/blueskyusf-code/MkDt
TERMUX_PKG_DESCRIPTION="Sistema modular para modificação de APKs e diagnóstico de hardware"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Programador Supremo <blueskyusf-code>"
TERMUX_PKG_VERSION=0.1.0
TERMUX_PKG_SRCURL=https://github.com/blueskyusf-code/MkDt/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
# Se o seu projeto não precisa compilar C (apenas scripts), use:
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
    # Aqui o sistema move os seus arquivos para o lugar certo no Android
    install -Dm755 $TERMUX_PKG_SRCDIR/install.sh $TERMUX_PREFIX/bin/mkdt-install
    
    # Cria a estrutura de pastas do OpenSP no sistema do usuário
    mkdir -p $TERMUX_PREFIX/share/mkdt/{bin,etc,lib,src,usr,tmp}
    cp -rv $TERMUX_PKG_SRCDIR/{bin,etc,lib,src}/* $TERMUX_PREFIX/share/mkdt/
}

