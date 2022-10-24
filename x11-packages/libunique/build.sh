TERMUX_PKG_HOMEPAGE=https://gnome.org
TERMUX_PKG_DESCRIPTION="Library for writing single instance applications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
# This specific package is for libunique-1.0.
_MAJOR_VERSION=1.1
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.6
TERMUX_PKG_REVISION=20
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/libunique/${_MAJOR_VERSION}/libunique-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=e5c8041cef8e33c55732f06a292381cb345db946cf792a4ae18aa5c66cdd4fbb
TERMUX_PKG_DEPENDS="glib, gtk2"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-dbus=no
--enable-introspection=yes
"

termux_step_pre_configure() {
	autoreconf -fi

	termux_setup_gir

	export CFLAGS="$CFLAGS -DG_CONST_RETURN=const"
}

termux_step_post_configure() {
	touch ./unique/g-ir-{scanner,compiler}
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libunique-1.0.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
