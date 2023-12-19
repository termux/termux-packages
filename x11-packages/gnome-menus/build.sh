TERMUX_PKG_HOMEPAGE=https://github.com/GNOME/gnome-menus
TERMUX_PKG_DESCRIPTION="GNOME menu specifications"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <dev.yisus@hotmail.com>"
TERMUX_PKG_VERSION="3.36.0"
TERMUX_PKG_SRCURL=https://github.com/GNOME/gnome-menus/archive/refs/tags/${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=2c7fb4011e1ebb41db1fe902b811ac216e1b54cc513e119a1729c08101edb942
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--host=$TERMUX_HOST_PLATFORM --disable-introspection"

termux_step_pre_configure() {
	./autogen.sh --host=$TERMUX_HOST_PLATFORM
	make distclean
}
