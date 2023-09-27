TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libhandy/
TERMUX_PKG_DESCRIPTION="Building blocks for modern adaptive GNOME apps"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.8
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libhandy/${_MAJOR_VERSION}/libhandy-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d11aa2cd3e570ac6d0efdba46d173147c11f45826457e924c05990bb2e0df9ad
TERMUX_PKG_DEPENDS="atk, fribidi, gdk-pixbuf, glib, gtk3, libcairo, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Dvapi=true
-Dtests=false
-Dexamples=false
-Dglade_catalog=disabled
"

termux_step_pre_configure() {
	termux_setup_gir
}
