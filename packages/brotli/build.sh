TERMUX_PKG_HOMEPAGE=https://github.com/google/brotli
TERMUX_PKG_DESCRIPTION="lossless compression algorithm and format (command line utility)"
TERMUX_PKG_VERSION=1.0.3
TERMUX_PKG_SRCURL=https://github.com/google/brotli/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7948154166ef8556f8426a4ede219aaa98a81a5baffe1f7cf2523fa67d59cd1c
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	./bootstrap
}

termux_step_post_make_install() {
	cp docs/brotli.1 $TERMUX_PREFIX/share/man/man1
	cp docs/*.3 $TERMUX_PREFIX/share/man/man3
}
