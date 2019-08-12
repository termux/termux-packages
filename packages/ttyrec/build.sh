TERMUX_PKG_HOMEPAGE=http://0xcc.net/ttyrec/
TERMUX_PKG_DESCRIPTION="Terminal recorder and player"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.0.8
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=http://0xcc.net/ttyrec/ttyrec-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ef5e9bf276b65bb831f9c2554cd8784bd5b4ee65353808f82b7e2aef851587ec
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -Dset_progname=setprogname $LDFLAGS"
}

termux_step_make_install() {
	cp ttyrec ttyplay ttytime $TERMUX_PREFIX/bin
	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp ttyrec.1 ttyplay.1 ttytime.1 $TERMUX_PREFIX/share/man/man1
}
