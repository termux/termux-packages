TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/pix
TERMUX_PKG_DESCRIPTION="Image management application"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.4.11"
TERMUX_PKG_SRCURL="https://github.com/linuxmint/pix/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=47ac74d19399fdde5d0e2e5d1c2b4a29c3281a549ca7881a1fb8457b1bf5c5eb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+(?!-)"
TERMUX_PKG_DEPENDS="glib, gtk3, libpng, zlib, gsettings-desktop-schemas, libjpeg-turbo, xapp, libwebp, libtiff, libcairo, pango, shared-mime-info, libx11, littlecms"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_PYTHON_COMMON_DEPS="itstool"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
