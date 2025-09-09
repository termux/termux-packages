TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gcab
TERMUX_PKG_DESCRIPTION="GObject library to create cabinet files"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gcab/${TERMUX_PKG_VERSION}/gcab-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2f0c9615577c4126909e251f9de0626c3ee7a152376c15b5544df10fc87e560b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocs=false
-Dintrospection=true
-Dvapi=true
-Dtests=false
-Dinstalled_tests=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
