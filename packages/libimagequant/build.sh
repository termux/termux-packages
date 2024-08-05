TERMUX_PKG_HOMEPAGE=https://pngquant.org/lib/
TERMUX_PKG_DESCRIPTION="Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.3.2"
TERMUX_PKG_SRCURL=https://github.com/ImageOptim/libimagequant/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a5c00a966bba20a58a30bb0a72c1eed4bcbaea3f4eb803f3ec274a726fade06b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/imagequant-sys"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"
}

termux_step_make() {
	:
}

termux_step_make_install() {
	termux_setup_rust
	termux_setup_cargo_c
	cargo cinstall \
		--target $CARGO_TARGET_NAME \
		--prefix $TERMUX_PREFIX \
		--jobs $TERMUX_PKG_MAKE_PROCESSES
}
