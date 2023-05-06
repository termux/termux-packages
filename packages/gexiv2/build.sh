TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/gexiv2
TERMUX_PKG_DESCRIPTION="A GObject-based Exiv2 wrapper"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=0.14
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gexiv2/${_MAJOR_VERSION}/gexiv2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ec3ee3ec3860b9c78958a55da89cf76ae2305848e12f41945b7b52124d8f6cf9
TERMUX_PKG_DEPENDS="exiv2, glib, libc++"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
-Dintrospection=true
-Dvapi=true
-Dpython3=false
"

termux_step_pre_configure() {
	termux_setup_gir

	CPPFLAGS+=" -D_LIBCPP_ENABLE_CXX17_REMOVED_FEATURES"
}
