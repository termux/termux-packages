TERMUX_PKG_HOMEPAGE="https://mate-desktop.org/"
TERMUX_PKG_DESCRIPTION="Power management tool for the MATE desktop"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.1"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/mate-power-manager/releases/download/v$TERMUX_PKG_VERSION/mate-power-manager-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256="8ebdcb74b607e868336ba9a8146cdef8f97bce535c2b0cb3bf650c58f71eee21"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus-glib, gettext, libc++, libcanberra, libnotify, libsecret, upower"
TERMUX_PKG_BUILD_DEPENDS="autoconf-archive, glib, mate-common, mate-panel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable-tests=false
"

termux_step_pre_configure() {
	rm -f configure
	termux_setup_glib_cross_pkg_config_wrapper
}
