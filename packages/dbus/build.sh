TERMUX_PKG_HOMEPAGE=https://dbus.freedesktop.org
TERMUX_PKG_DESCRIPTION="Freedesktop.org message bus system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.14.0
TERMUX_PKG_SRCURL="https://dbus.freedesktop.org/releases/dbus/dbus-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=ccd7cce37596e0a19558fd6648d1272ab43f011d80c8635aea8fd0bad58aebd4
TERMUX_PKG_DEPENDS="libexpat, libx11"
TERMUX_PKG_BREAKS="dbus-dev"
TERMUX_PKG_REPLACES="dbus-dev"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
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
