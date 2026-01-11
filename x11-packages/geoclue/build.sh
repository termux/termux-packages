TERMUX_PKG_HOMEPAGE="https://gitlab.freedesktop.org/geoclue/geoclue/-/wikis/home"
TERMUX_PKG_DESCRIPTION="Modular geoinformation service built on the D-Bus messaging system"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.0"
TERMUX_PKG_SRCURL="https://gitlab.freedesktop.org/geoclue/geoclue/-/archive/${TERMUX_PKG_VERSION}/geoclue-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="8d1804b3d9d51c2a17af67c882ff5f9169724e248d39ccc3cfa8dba5d9323be7"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, json-glib, libc++, libsoup3"
TERMUX_PKG_BUILD_DEPENDS="gobject-introspection, libnotify"
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
