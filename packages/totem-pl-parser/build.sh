TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/totem-pl-parser
TERMUX_PKG_DESCRIPTION="Simple GObject-based library to parse and save a host of playlist formats"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.26.6"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/totem-pl-parser/${TERMUX_PKG_VERSION%.*}/totem-pl-parser-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c0df0f68d5cf9d7da43c81c7f13f11158358368f98c22d47722f3bd04bd3ac1c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libarchive, libgcrypt, libxml2"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable-gtk-doc=false
-Denable-libarchive=yes
-Denable-libgcrypt=yes
-Dintrospection=true
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	# Fix linker script error
	LDFLAGS+=" -Wl,--undefined-version"
}
