TERMUX_PKG_HOMEPAGE=http://0xcc.net/ttyrec/
TERMUX_PKG_DESCRIPTION="Terminal recorder and player"
TERMUX_PKG_VERSION=1.0.8
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://0xcc.net/ttyrec/ttyrec-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make_install () {
        cp ttyrec ttyplay ttytime $TERMUX_PREFIX/bin
        mkdir -p $TERMUX_PREFIX/share/man/man1
        cp ttyrec.1 ttyplay.1 ttytime.1 $TERMUX_PREFIX/share/man/man1
}
