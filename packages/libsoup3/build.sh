TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/libsoup
TERMUX_PKG_DESCRIPTION="HTTP client and server library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=3.2
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libsoup/${_MAJOR_VERSION}/libsoup-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b1eb3d2c3be49fbbd051a71f6532c9626bcecea69783190690cd7e4dfdf28f29
TERMUX_PKG_DEPENDS="brotli, glib, libnghttp2, libpsl, libsqlite, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_RECOMMENDS="glib-networking"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Dvapi=enabled
-Ddocs=disabled
-Dgssapi=disabled
-Dtls_check=false
-Dsysprof=disabled
"

termux_step_pre_configure() {
	termux_setup_gir
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libsoup-3.0.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
