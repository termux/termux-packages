TERMUX_PKG_HOMEPAGE=https://codeberg.org/dnkl/foot
TERMUX_PKG_DESCRIPTION="Fast, lightweight and minimalistic Wayland terminal emulator"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.23.1"
TERMUX_PKG_SRCURL=https://codeberg.org/dnkl/foot/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=02072b8f0aaf26907b6b02293c875539ce52fc59079344e7cf811ab03394cfa3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, fontconfig, freetype, libfcft, libpixman, libwayland, libxkbcommon, utf8proc"
TERMUX_PKG_BUILD_DEPENDS="libtllist, libwayland-protocols, libwayland-cross-scanner, scdoc, xdg-utils"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocs=enabled
-Dterminfo-base-name=foot-extra
-Dtests=false
"

termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper

	# libandroid-support provides this
	export CPPFLAGS+=" -D__STDC_ISO_10646__=201103L"

	cp "${TERMUX_PKG_BUILDER_DIR}/reallocarray.c" "${TERMUX_PKG_SRCDIR}"
}
