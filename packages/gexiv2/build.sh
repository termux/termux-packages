TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/gexiv2
TERMUX_PKG_DESCRIPTION="A GObject-based Exiv2 wrapper"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.6"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gexiv2/${TERMUX_PKG_VERSION%.*}/gexiv2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=606c28aaae7b1f3ef5c8eabe5e7dffd7c5a1c866d25b7671fb847fe287a72b8b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="exiv2, glib, libc++"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
-Dintrospection=true
-Dvapi=true
-Dpython3=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
