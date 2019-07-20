TERMUX_PKG_HOMEPAGE=http://www.pixman.org/
TERMUX_PKG_DESCRIPTION="Low-level library for pixel manipulation"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=0.38.4
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://cairographics.org/releases/pixman-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=da66d6fd6e40aee70f7bd02e4f8f76fc3f006ec879d346bae6a723025cfbdde7
TERMUX_PKG_BREAKS="libpixman-dev"
TERMUX_PKG_REPLACES="libpixman-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-libpng"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = arm ]; then
		CFLAGS+=" -fno-integrated-as"
	fi
}
