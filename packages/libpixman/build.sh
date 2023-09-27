TERMUX_PKG_HOMEPAGE=http://www.pixman.org/
TERMUX_PKG_DESCRIPTION="Low-level library for pixel manipulation"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.42.2
TERMUX_PKG_SRCURL=https://cairographics.org/releases/pixman-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ea1480efada2fd948bc75366f7c349e1c96d3297d09a3fe62626e38e234a625e
TERMUX_PKG_BUILD_DEPENDS="binutils-cross"
TERMUX_PKG_BREAKS="libpixman-dev"
TERMUX_PKG_REPLACES="libpixman-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-libpng"

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" = arm ] || [ "$TERMUX_ARCH" = aarch64 ]; then
		termux_setup_no_integrated_as
	fi
}
