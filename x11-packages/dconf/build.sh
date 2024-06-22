TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/dconf
TERMUX_PKG_DESCRIPTION="dconf is a simple key/value storage system that is heavily optimised for reading"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.40.0"
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/dconf/-/archive/${TERMUX_PKG_VERSION}/dconf-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c144c314a5ab1b0e2c2e5cb381658d19b9577511b62db5df3fac463028b61bca
TERMUX_PKG_DEPENDS="dbus, glib"
TERMUX_PKG_BUILD_DEPENDS="glib-bin, glib-cross"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbash_completion=false
-Dvapi=false
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
