TERMUX_PKG_HOMEPAGE=https://github.com/google/brotli
TERMUX_PKG_DESCRIPTION="lossless compression algorithm and format (command line utility)"
TERMUX_PKG_VERSION=1.0.4
TERMUX_PKG_SHA256=2268a3dff1cc36e18549e89a51ee0cd9513908a977d56d6a1f9d4c61c2af37c3
TERMUX_PKG_SRCURL=https://github.com/google/brotli/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_FORCE_CMAKE=yes

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man{1,3}
	cp $TERMUX_PKG_SRCDIR/docs/brotli.1 $TERMUX_PREFIX/share/man/man1/
	cp $TERMUX_PKG_SRCDIR/docs/*.3 $TERMUX_PREFIX/share/man/man3/
}
