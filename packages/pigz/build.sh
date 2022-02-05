TERMUX_PKG_HOMEPAGE=https://www.zlib.net/pigz
TERMUX_PKG_DESCRIPTION="Parallel implementation of the gzip file compressor"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.7
TERMUX_PKG_SRCURL=https://www.zlib.net/pigz/pigz-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b4c9e60344a08d5db37ca7ad00a5b2c76ccb9556354b722d56d55ca7e8b1c707
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 pigz $TERMUX_PREFIX/bin/pigz
	ln -sfr $TERMUX_PREFIX/bin/pigz $TERMUX_PREFIX/bin/unpigz
	install -Dm600 pigz.1 $TERMUX_PREFIX/share/man/man1/pigz.1
}
