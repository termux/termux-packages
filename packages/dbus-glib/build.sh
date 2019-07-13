TERMUX_PKG_HOMEPAGE=https://dbus.freedesktop.org
TERMUX_PKG_DESCRIPTION="GLib bindings for DBUS"
TERMUX_PKG_LICENSE="GPL"
TERMUX_PKG_MAINTAINER="Tristan Ross <spaceboyross@yandex.com>"
TERMUX_PKG_VERSION=0.110
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=7ce4760cf66c69148f6bd6c92feaabb8812dee30846b24cd0f7395c436d7e825
TERMUX_PKG_DEPENDS="dbus, glib"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	(cd $TERMUX_PKG_SRCDIR && autoconf -i)
	$TERMUX_PKG_SRCDIR/configure
	make -j $TERMUX_MAKE_PROCESSES
}

termux_step_pre_configure() {
	autoconf -i
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-dbus-binding-tool=$TERMUX_PKG_HOSTBUILD_DIR/dbus/dbus-binding-tool"
}
