TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/GtkSourceView
TERMUX_PKG_DESCRIPTION="A GNOME library that extends GtkTextView"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.8.4"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gtksourceview/${TERMUX_PKG_VERSION%.*}/gtksourceview-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7ec9d18fb283d1f84a3a3eff3b7a72b09a10c9c006597b3fbabbb5958420a87d
TERMUX_PKG_DEPENDS="atk, fribidi, gdk-pixbuf, glib, gtk3, libcairo, libxml2, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgir=true
-Dvapi=true
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
	local _GUARD_FILE="lib/libgtksourceview-4.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
