TERMUX_PKG_HOMEPAGE=https://dbus.freedesktop.org
TERMUX_PKG_DESCRIPTION="Freedesktop.org message bus system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.15.6
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://dbus.freedesktop.org/releases/dbus/dbus-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=f97f5845f9c4a5a1fb3df67dfa9e16b5a3fd545d348d6dc850cb7ccc9942bd8c
TERMUX_PKG_DEPENDS="libexpat, libx11"
TERMUX_PKG_BREAKS="dbus-dev"
TERMUX_PKG_REPLACES="dbus-dev"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_close_range=no
--enable-ld-version-script
--disable-libaudit
--disable-systemd
--disable-tests
--enable-x11-autolaunch
--with-test-socket-dir=$TERMUX_PREFIX/tmp
--with-session-socket-dir=$TERMUX_PREFIX/tmp
--with-x=auto
"

termux_step_pre_configure() {
	export LIBS="-llog"
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/var/run/dbus
	echo "dbus needs this folder to put pid and system_bus_socket" >> $TERMUX_PREFIX/var/run/dbus/README.dbus
}

termux_step_create_debscripts() {
	{
		echo "#!${TERMUX_PREFIX}/bin/sh"
		echo "if [ ! -e ${TERMUX_PREFIX}/var/lib/dbus/machine-id ]; then"
		echo "mkdir -p ${TERMUX_PREFIX}/var/lib/dbus"
		echo "dbus-uuidgen > ${TERMUX_PREFIX}/var/lib/dbus/machine-id"
		echo "fi"
		echo "exit 0"
	} > postinst
}
