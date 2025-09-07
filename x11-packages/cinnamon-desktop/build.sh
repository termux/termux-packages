TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/cinnamon-desktop
TERMUX_PKG_DESCRIPTION="The cinnamon-desktop library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.1"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/linuxmint/cinnamon-desktop/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0e9af48b97910302a1130424a05c63b2e7aacb4ce6ae7a1d53c71bcd157a3a8f
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="glib, gtk3, libcairo, libx11, libxext, xkeyboard-config, libxkbfile, gobject-introspection, libxrandr, iso-codes, pulseaudio, gdk-pixbuf, gigolo, cinnamon-menus"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsystemd=disabled
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
	termux_setup_meson
	termux_setup_gir

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
