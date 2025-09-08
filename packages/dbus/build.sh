TERMUX_PKG_HOMEPAGE=https://dbus.freedesktop.org
TERMUX_PKG_DESCRIPTION="Freedesktop.org message bus system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.16.2"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://dbus.freedesktop.org/releases/dbus/dbus-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=0ba2a1a4b16afe7bceb2c07e9ce99a8c2c3508e5dec290dbb643384bd6beb7e2
TERMUX_PKG_DEPENDS="libexpat, libx11"
TERMUX_PKG_BREAKS="dbus-dev"
TERMUX_PKG_REPLACES="dbus-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibaudit=disabled
-Dsystemd=disabled
-Dmodular_tests=disabled
-Dx11_autolaunch=enabled
-Dtest_socket_dir=$TERMUX_PREFIX/tmp
-Dsession_socket_dir=$TERMUX_PREFIX/tmp
"

termux_step_pre_configure() {
	export LIBS="-llog"
	# Enforce meson building
	rm CMakeLists.txt
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
