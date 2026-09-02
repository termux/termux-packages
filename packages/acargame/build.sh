TERMUX_PKG_HOMEPAGE=https://github.com/Rocripts/ACarGame
TERMUX_PKG_DESCRIPTION="A simple C terminal car game"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="rioareos"
TERMUX_PKG_VERSION=1.0.0

TERMUX_PKG_SRCURL=https://github.com/Rocripts/ACarGame/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2e76e509d5956046b9bd948a6fa46e59cb978f8c77972971ca8b223843d26cc1

termux_step_make() {
    $CC $CFLAGS $CPPFLAGS $LDFLAGS \
        "$TERMUX_PKG_SRCDIR/file.c" \
        -o "$TERMUX_PKG_BUILDDIR/acargame"
}

termux_step_make_install() {
    install -Dm755 \
        "$TERMUX_PKG_BUILDDIR/acargame" \
        "$TERMUX_PREFIX/bin/acargame"
}
