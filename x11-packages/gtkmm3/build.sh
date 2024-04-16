TERMUX_PKG_HOMEPAGE=https://www.gtkmm.org/
TERMUX_PKG_DESCRIPTION="The C++ API for GTK"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.24.9"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gtkmm/${TERMUX_PKG_VERSION%.*}/gtkmm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=30d5bfe404571ce566a8e938c8bac17576420eb508f1e257837da63f14ad44ce
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libatkmm-1.6, libc++, libcairomm-1.0, libglibmm-2.4, libpangomm-1.4, libsigc++-2.0"
TERMUX_PKG_BUILD_DEPENDS="glib-cross, libepoxy"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbuild-demos=false
-Dbuild-tests=false
"

termux_step_pre_configure() {
	local _WRAPPER_BIN="${TERMUX_PKG_BUILDDIR}/_wrapper/bin"
	mkdir -p "${_WRAPPER_BIN}"
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		sed "s|^export PKG_CONFIG_LIBDIR=|export PKG_CONFIG_LIBDIR=${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:|" \
			"${TERMUX_STANDALONE_TOOLCHAIN}/bin/pkg-config" \
			> "${_WRAPPER_BIN}/pkg-config"
		chmod +x "${_WRAPPER_BIN}/pkg-config"
		export PKG_CONFIG="${_WRAPPER_BIN}/pkg-config"
	fi
	export PATH="${_WRAPPER_BIN}:${PATH}"
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libgtkmm-3.0.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
