TERMUX_PKG_HOMEPAGE=https://pngquant.org/lib/
TERMUX_PKG_DESCRIPTION="Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.2.2"
TERMUX_PKG_SRCURL=https://github.com/ImageOptim/libimagequant/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ff1a34d3df9a1a5e5c1fa3895c036a885dc7b9740d7fccdf57e9ed678b8fb3a3
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
		--jobs $TERMUX_MAKE_PROCESSES
}
