TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/bat
TERMUX_PKG_DESCRIPTION="A cat(1) clone with wings"
TERMUX_PKG_VERSION=0.9.0
TERMUX_PKG_SHA256=4ce9c118cf5da1159a882dea389f3c5737b5d98192e9a619b0fe8c1730341cc6
TERMUX_PKG_SRCURL=https://github.com/sharkdp/bat/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/bat.1 $TERMUX_PREFIX/share/man/man1/
}
