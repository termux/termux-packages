TERMUX_PKG_HOMEPAGE="https://github.com/adah1972/libunibreak"
TERMUX_PKG_DESCRIPTION="Unicode line-breaking library"
TERMUX_PKG_LICENSE="ZLIB, Libpng"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.0.1"
TERMUX_PKG_SRCURL="https://github.com/adah1972/libunibreak/archive/libunibreak_${TERMUX_PKG_VERSION//./_}.tar.gz"
TERMUX_PKG_SHA256=96e9074daf1f45ae9ddf461b5a9801991a6fe8b2025ea786486e0e023c34a2c5
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
