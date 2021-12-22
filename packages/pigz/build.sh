TERMUX_PKG_HOMEPAGE=https://www.zlib.net/pigz
TERMUX_PKG_DESCRIPTION="Parallel implementation of the gzip file compressor"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6
TERMUX_PKG_SRCURL=https://www.zlib.net/pigz/pigz-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2eed7b0d7449d1d70903f2a62cd6005d262eb3a8c9e98687bc8cbb5809db2a7d
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 pigz $TERMUX_PREFIX/bin/pigz
	ln -sfr $TERMUX_PREFIX/bin/pigz $TERMUX_PREFIX/bin/unpigz
	install -Dm600 pigz.1 $TERMUX_PREFIX/share/man/man1/pigz.1
}
