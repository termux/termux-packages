TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/libsoup
TERMUX_PKG_DESCRIPTION="HTTP client and server library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.4.4"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libsoup/${TERMUX_PKG_VERSION%.*}/libsoup-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=291c67725f36ed90ea43efff25064b69c5a2d1981488477c05c481a3b4b0c5aa
TERMUX_PKG_DEPENDS="brotli, glib, libnghttp2, libpsl, libsqlite, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_RECOMMENDS="glib-networking"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Dvapi=enabled
-Ddocs=disabled
-Dgssapi=disabled
-Dtests=false
-Dtls_check=false
-Dsysprof=disabled
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libsoup-3.0.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
