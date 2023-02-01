TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libhandy/
TERMUX_PKG_DESCRIPTION="Building blocks for modern adaptive GNOME apps"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.8
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libhandy/${_MAJOR_VERSION}/libhandy-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3766b9a881fe0658cc6080453a2219086c3f6dbd82069de409b8ab3f59948a70
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
