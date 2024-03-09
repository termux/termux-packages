TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libhandy/
TERMUX_PKG_DESCRIPTION="Building blocks for modern adaptive GNOME apps"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.8
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.3
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libhandy/${_MAJOR_VERSION}/libhandy-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=05b497229073ff557f10b326e074c5066f8743a302d4820ab97bcb5cd2dab087
TERMUX_PKG_DEPENDS="atk, fribidi, gdk-pixbuf, glib, gtk3, libcairo, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Dvapi=true
-Dtests=false
-Dexamples=false
-Dglade_catalog=disabled
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
