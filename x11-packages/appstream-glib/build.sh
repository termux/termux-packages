TERMUX_PKG_HOMEPAGE=https://people.freedesktop.org/~hughsient/appstream-glib/
TERMUX_PKG_DESCRIPTION="Provides GObjects and helper methods to make it easy to read and write AppStream metadata"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.3"
TERMUX_PKG_SRCURL=https://people.freedesktop.org/~hughsient/appstream-glib/releases/appstream-glib-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=84754064c560fca6e1ab151dc64354fc235a5798f016b91b38c9617253a8cf11
TERMUX_PKG_DEPENDS="fontconfig, freetype, gdk-pixbuf, glib, gtk3, json-glib, libarchive, libcairo, libcurl, libstemmer, libuuid, libyaml, pango"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Drpm=false
-Dgtk-doc=false
-Dintrospection=true
"

termux_step_pre_configure() {
	TERMUX_PKG_VERSION=. termux_setup_gir

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
