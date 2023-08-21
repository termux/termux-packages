TERMUX_PKG_HOMEPAGE=https://www.zlib.net/pigz
TERMUX_PKG_DESCRIPTION="Parallel implementation of the gzip file compressor"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.8
TERMUX_PKG_SRCURL=https://www.zlib.net/pigz/pigz-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=eb872b4f0e1f0ebe59c9f7bd8c506c4204893ba6a8492de31df416f0d5170fd0
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 pigz $TERMUX_PREFIX/bin/pigz
	ln -sfr $TERMUX_PREFIX/bin/pigz $TERMUX_PREFIX/bin/unpigz
	install -Dm600 pigz.1 $TERMUX_PREFIX/share/man/man1/pigz.1
}
