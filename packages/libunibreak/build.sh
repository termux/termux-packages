TERMUX_PKG_HOMEPAGE="https://github.com/adah1972/libunibreak/"
TERMUX_PKG_DESCRIPTION="An implementation of the line breaking algorithm as described in Unicode 5.2.0 Standard Annex 14, Revision 24"
TERMUX_PKG_LICENSE="ZLIB, Libpng"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.1
TERMUX_PKG_SRCURL="https://github.com/adah1972/libunibreak/archive/libunibreak_${TERMUX_PKG_VERSION//./_}.tar.gz"
TERMUX_PKG_SHA256=890674996168ef5ba143d80d49ab8b61594a4eb70198dcac76caf6e1bd264a41
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
