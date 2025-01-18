TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Libgee
TERMUX_PKG_DESCRIPTION="A collection library providing GObject-based interfaces and classes for commonly used data structures"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.20.8"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libgee/${TERMUX_PKG_VERSION%.*}/libgee-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=189815ac143d89867193b0c52b7dc31f3aa108a15f04d6b5dca2b6adfad0b0ee
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
--enable-vala
"

termux_step_pre_configure() {
	termux_setup_gir
}
