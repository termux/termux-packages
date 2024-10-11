TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/gexiv2
TERMUX_PKG_DESCRIPTION="A GObject-based Exiv2 wrapper"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gexiv2/${TERMUX_PKG_VERSION%.*}/gexiv2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=21e64d2c56e9b333d44fef3f2a4b25653d922c419acd972fa96fab695217e2c8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="exiv2, glib, libc++"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
-Dintrospection=true
-Dvapi=true
-Dpython3=false
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
