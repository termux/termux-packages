TERMUX_PKG_HOMEPAGE=https://gnome.org
TERMUX_PKG_DESCRIPTION="Library for writing single instance applications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.2"
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/libunique/${TERMUX_PKG_VERSION%.*}/libunique-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=50269a87c7aabf1e25f01b3bbb280133138ffd7b6776289894c614a4b6ca968d
TERMUX_PKG_DEPENDS="glib, gtk2"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_MAKE_ARGS="V=1"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-dbus=no
--enable-introspection=yes
"

termux_step_pre_configure() {
	autoreconf -fi

	termux_setup_gir

	export CFLAGS="$CFLAGS -DG_CONST_RETURN=const"
	export GLIB_GENMARSHAL=$(command -v glib-genmarshal)
	export GLIB_MKENUMS=$(command -v glib-mkenums)
}

termux_step_post_configure() {
	touch ./unique/g-ir-{scanner,compiler}
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libunique-3.0.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
