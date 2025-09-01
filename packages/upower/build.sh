TERMUX_PKG_HOMEPAGE=https://upower.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Power management support for DeviceKit"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.90.9"
TERMUX_PKG_SRCURL="https://gitlab.freedesktop.org/upower/upower/-/archive/v$TERMUX_PKG_VERSION/upower-v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=fffd45c50d29ed73ecdcfb11c3a7bb042ef14e84b14b0c2d5fdb78c7b4435d6c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gobject-introspection"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Dos_backend=dummy
-Dpolkit=disabled
-Dsystemdsystemunitdir=no
-Dgtk-doc=false
-Dman=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
