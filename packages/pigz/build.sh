TERMUX_PKG_HOMEPAGE=https://www.zlib.net/pigz
TERMUX_PKG_DESCRIPTION="Parallel implementation of the gzip file compressor"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.5
TERMUX_PKG_SRCURL=https://www.zlib.net/pigz/pigz-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a006645702caaecace633a89eb5c371482b44a48d04f34e0058e2b85d75d4c36
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 pigz $TERMUX_PREFIX/bin/pigz
	ln -sfr $TERMUX_PREFIX/bin/pigz $TERMUX_PREFIX/bin/unpigz
	install -Dm600 pigz.1 $TERMUX_PREFIX/share/man/man1/pigz.1
}
