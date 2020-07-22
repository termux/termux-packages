TERMUX_PKG_HOMEPAGE=https://dbus.freedesktop.org
TERMUX_PKG_DESCRIPTION="Freedesktop.org message bus system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.12.18
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://dbus.freedesktop.org/releases/dbus/dbus-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=64cf4d70840230e5e9bc784d153880775ab3db19d656ead8a0cb9c0ab5a95306
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
--with-x
"

termux_step_pre_configure() {
	export LIBS="-llog"
	autoreconf -fi
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
