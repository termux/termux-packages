TERMUX_PKG_HOMEPAGE=https://libportal.org/
TERMUX_PKG_DESCRIPTION="Flatpak portal library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.0"
TERMUX_PKG_SRCURL=https://github.com/flatpak/libportal/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ff98d6376980a698273023eda1a93487014d51aaac6a54c6516a6954f2b14188
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac, glib-cross"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbackend-gtk3=enabled
-Dbackend-gtk4=enabled
-Dbackend-qt5=enabled
-Dintrospection=true
-Dvapi=true
-Ddocs=false
-Dtests=false
"

termux_step_pre_configure() {
	TERMUX_PKG_VERSION=. termux_setup_gir
	export PKG_CONFIG_LIBDIR="${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:${PKG_CONFIG_LIBDIR}"
}
