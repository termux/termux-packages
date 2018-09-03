TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/fd
TERMUX_PKG_DESCRIPTION="Simple, fast and user-friendly alternative to find"
TERMUX_PKG_VERSION=7.1.0
TERMUX_PKG_SHA256=9385a55738947f69fd165781598de6c980398c6214a4927fce13a4f7f1e63d4d
TERMUX_PKG_SRCURL=https://github.com/sharkdp/fd/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_make_install() {
	cp target/$CARGO_TARGET_NAME/release/fd $TERMUX_PREFIX/bin/fd

	mkdir -p  $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/fd.1 $TERMUX_PREFIX/share/man/man1/fd.1
}
