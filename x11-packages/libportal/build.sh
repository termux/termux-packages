TERMUX_PKG_HOMEPAGE=https://libportal.org/
TERMUX_PKG_DESCRIPTION="Flatpak portal library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.0"
TERMUX_PKG_SRCURL=https://github.com/flatpak/libportal/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=71482afa68b3373268e7df7feaf96ce99eb1a6701f60ff43a0d1b2594605eae8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbackend-gtk3=enabled
-Dbackend-gtk4=enabled
-Dbackend-qt6=enabled
-Dintrospection=true
-Dvapi=true
-Ddocs=false
-Dtests=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
