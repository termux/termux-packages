TERMUX_PKG_HOMEPAGE=https://github.com/djunekz/tdoc
TERMUX_PKG_DESCRIPTION="TDOC — Diagnostic and repair utility for Termux environment"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@djunekz"
TERMUX_PKG_VERSION=1.0.4

TERMUX_PKG_SRCURL=https://github.com/djunekz/tdoc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=413f200673039d2f1ed78e97a10bb6c8605cc9215df46c9002340e2da7c07695

TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_DEPENDS="bash, coreutils, curl, git, gnupg, termux-tools"

termux_step_make_install() {
    install -d "$TERMUX_PREFIX/lib/tdoc"

    cp -r core modules data tdoc "$TERMUX_PREFIX/lib/tdoc/"

    install -Dm755 "$TERMUX_PREFIX/lib/tdoc/tdoc" "$TERMUX_PREFIX/bin/tdoc"

    if [[ -f man/tdoc.1 ]]; then
        install -Dm644 man/tdoc.1 "$TERMUX_PREFIX/share/man/man1/tdoc.1"
    fi

    install -Dm644 LICENSE "$TERMUX_PREFIX/share/licenses/tdoc/LICENSE"

    install -d "$TERMUX_PREFIX/var/lib/tdoc"
}
