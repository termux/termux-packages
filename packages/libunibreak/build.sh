TERMUX_PKG_HOMEPAGE="https://github.com/adah1972/libunibreak"
TERMUX_PKG_DESCRIPTION="Unicode line-breaking library"
TERMUX_PKG_LICENSE="ZLIB, Libpng"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.0"
TERMUX_PKG_SRCURL="https://github.com/adah1972/libunibreak/archive/libunibreak_${TERMUX_PKG_VERSION//./_}.tar.gz"
TERMUX_PKG_SHA256=35f1008184c13de55793fa292b62a0c10739f1294f401a3b6a772edc145a4b3b
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
