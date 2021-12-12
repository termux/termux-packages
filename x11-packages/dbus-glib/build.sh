TERMUX_PKG_HOMEPAGE=https://dbus.freedesktop.org
TERMUX_PKG_DESCRIPTION="GLib bindings for DBUS"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.112
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=7d550dccdfcd286e33895501829ed971eeb65c614e73aadb4a08aeef719b143a
TERMUX_PKG_DEPENDS="dbus, glib"
TERMUX_PKG_BREAKS="dbus-glib-dev"
TERMUX_PKG_REPLACES="dbus-glib-dev"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	(cd $TERMUX_PKG_SRCDIR && autoconf -i)
	$TERMUX_PKG_SRCDIR/configure
	make -j $TERMUX_MAKE_PROCESSES
}

termux_step_pre_configure() {
	export GLIB_GENMARSHAL=glib-genmarshal
	autoconf -i
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-dbus-binding-tool=$TERMUX_PKG_HOSTBUILD_DIR/dbus/dbus-binding-tool"
}
