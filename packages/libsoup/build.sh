TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/libsoup
TERMUX_PKG_DESCRIPTION="HTTP client and server library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# This specific package is for libsoup-2.4.
# libsoup-3.0 is packaged as libsoup3.
TERMUX_PKG_VERSION=2.74.3
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libsoup/${TERMUX_PKG_VERSION%.*}/libsoup-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e4b77c41cfc4c8c5a035fcdc320c7bc6cfb75ef7c5a034153df1413fa1d92f13
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="brotli, glib, libpsl, libsqlite, libxml2, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_RECOMMENDS="glib-networking"
TERMUX_PKG_BREAKS="libsoup-dev"
TERMUX_PKG_REPLACES="libsoup-dev"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Dvapi=enabled
-Dgssapi=disabled
-Dtls_check=false
-Dsysprof=disabled
"

termux_step_pre_configure() {
	termux_setup_gir

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
	local _GUARD_FILE="lib/libsoup-2.4.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
