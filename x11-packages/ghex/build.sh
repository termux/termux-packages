TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Ghex
TERMUX_PKG_DESCRIPTION="A simple binary editor for the Gnome desktop."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=44
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/ghex/${_MAJOR_VERSION}/ghex-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=58aa47cfdbed1280a3c131951c1a24596129404a0b0d347a3dbfffb6ff683976
TERMUX_PKG_DEPENDS="glib, gtk4, libadwaita, libcairo, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
"

termux_step_pre_configure() {
	termux_setup_gir
}
