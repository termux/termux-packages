TERMUX_PKG_HOMEPAGE=https://github.com/google/brotli
TERMUX_PKG_DESCRIPTION="lossless compression algorithm and format (command line utility)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.0.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=4c61bfb0faca87219ea587326c467b95acb25555b53d1a421ffa3c8a9296ee2c
TERMUX_PKG_BREAKS="brotli-dev"
TERMUX_PKG_REPLACES="brotli-dev"
TERMUX_PKG_SRCURL=https://github.com/google/brotli/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_FORCE_CMAKE=true

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man{1,3}
	cp $TERMUX_PKG_SRCDIR/docs/brotli.1 $TERMUX_PREFIX/share/man/man1/
	cp $TERMUX_PKG_SRCDIR/docs/*.3 $TERMUX_PREFIX/share/man/man3/
}
