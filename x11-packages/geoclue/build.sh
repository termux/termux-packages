TERMUX_PKG_HOMEPAGE="https://gitlab.freedesktop.org/geoclue/geoclue/-/wikis/home"
TERMUX_PKG_DESCRIPTION="Modular geoinformation service built on the D-Bus messaging system"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.1"
TERMUX_PKG_SRCURL="https://gitlab.freedesktop.org/geoclue/geoclue/-/archive/${TERMUX_PKG_VERSION}/geoclue-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=29dd143845ef270a06971c9edc98cdcf71aaad114cfb48dd1c803269c389a483
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, json-glib, libnotify, libsoup3"
TERMUX_PKG_BUILD_DEPENDS="gobject-introspection, libnotify"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dmodem-gps-source=false
-D3g-source=false
-Dcdma-source=false
-Dintrospection=true
-Dnmea-source=false
-Dgtk-doc=false
"

termux_step_pre_configure() {
	termux_setup_gir
}
