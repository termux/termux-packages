TERMUX_PKG_HOMEPAGE=https://lz4.github.io/lz4/
TERMUX_PKG_DESCRIPTION="Fast LZ compression algorithm library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.4
TERMUX_PKG_SRCURL=https://github.com/lz4/lz4/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0b0e3aa07c8c063ddf40b082bdf7e37a1562bda40a0ff5272957f3e987e0e54b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="liblz4-dev"
TERMUX_PKG_REPLACES="liblz4-dev"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+=/build/cmake
}

termux_step_post_make_install() {
	# Rebuild all dependent packages to remove this.
	ln -sf liblz4.so "${TERMUX_PREFIX}/lib/liblz4.so.${TERMUX_PKG_VERSION}"
	ln -sf liblz4.so "${TERMUX_PREFIX}/lib/liblz4.so.${TERMUX_PKG_VERSION//.*}"
}
