TERMUX_PKG_HOMEPAGE=http://www.pixman.org/
TERMUX_PKG_DESCRIPTION="Low-level library for pixel manipulation"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=0.38.0
TERMUX_PKG_SHA256=a7592bef0156d7c27545487a52245669b00cf7e70054505381cff2136d890ca8
TERMUX_PKG_SRCURL=https://cairographics.org/releases/pixman-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-libpng"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = arm ]; then
		CFLAGS+=" -fno-integrated-as"
	fi
}
