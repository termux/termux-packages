TERMUX_PKG_HOMEPAGE=http://www.pixman.org/
TERMUX_PKG_DESCRIPTION="Low-level library for pixel manipulation"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.40.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://cairographics.org/releases/pixman-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6d200dec3740d9ec4ec8d1180e25779c00bc749f94278c8b9021f5534db223fc
TERMUX_PKG_BREAKS="libpixman-dev"
TERMUX_PKG_REPLACES="libpixman-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-libpng"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = arm ]; then
		CFLAGS+=" -fno-integrated-as"
	fi
}
