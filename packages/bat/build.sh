TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/bat
TERMUX_PKG_DESCRIPTION="A cat(1) clone with wings"
TERMUX_PKG_VERSION=0.8.0
TERMUX_PKG_SHA256=577664399cf24695f51b702350c1a3fe460cd296a6a12ed0938bb937a4b3b00d
TERMUX_PKG_SRCURL=https://github.com/sharkdp/bat/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/bat.1 $TERMUX_PREFIX/share/man/man1/
}
