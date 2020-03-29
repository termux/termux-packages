TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/fd
TERMUX_PKG_DESCRIPTION="Simple, fast and user-friendly alternative to find"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=7.5.0
TERMUX_PKG_SRCURL=https://github.com/sharkdp/fd/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8a78ca24323c832cf205c1fce8276fc25ae90371531c32e155301937986ea713
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	mkdir -p  $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/fd.1 $TERMUX_PREFIX/share/man/man1/fd.1
}
