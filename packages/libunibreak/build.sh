TERMUX_PKG_HOMEPAGE="https://github.com/adah1972/libunibreak"
TERMUX_PKG_DESCRIPTION="Unicode line-breaking library"
TERMUX_PKG_LICENSE="ZLIB, Libpng"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.0
TERMUX_PKG_SRCURL="https://github.com/adah1972/libunibreak/archive/libunibreak_${TERMUX_PKG_VERSION//./_}.tar.gz"
TERMUX_PKG_SHA256=e4cb1a0d9aebb129c9856ec75e3d98e675997e385cce4e0106ef8f68e09afaa3
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
