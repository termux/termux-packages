TERMUX_PKG_HOMEPAGE=https://github.com/bootchk/resynthesizer
TERMUX_PKG_DESCRIPTION="Suite of gimp plugins for texture synthesis"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_SRCURL=https://github.com/bootchk/resynthesizer/archive/refs/tags/v${TERMUX_PKG_VERSION%.*}.tar.gz
TERMUX_PKG_SHA256=d0f459e551d428e3cd3fec4c3ebfe448e6e2947d9b24553373308d6d41ddd580
TERMUX_PKG_DEPENDS="gimp, python"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_meson
	termux_setup_cmake
}

termux_step_configure() {
	mkdir -p build
	$TERMUX_MESON setup build \
		--prefix="$TERMUX_PREFIX" \
		--buildtype=release \
		--cross-file="$TERMUX_MESON_CROSSFILE"
}

termux_step_make() {
	ninja -C build
}

termux_step_make_install() {
	ninja -C build install
}
