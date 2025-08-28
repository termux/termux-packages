TERMUX_PKG_HOMEPAGE=https://github.com/xapp-project/libadapta
TERMUX_PKG_DESCRIPTION="libAdapta is libAdwaita with theme support and a few extra"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.0"
TERMUX_PKG_SRCURL="https://github.com/xapp-project/libadapta/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=725daa7433497b3ae541ba72fe7a075ec1a99693c5598a6c56706f0c3a1f26c9
TERMUX_PKG_DEPENDS="appstream, sassc, fribidi, glib, graphene, gtk4, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Dvapi=true
-Dtests=false
-Dexamples=true
-Dc_args=-Wno-error=format-nonliteral
"

termux_step_post_get_source() {
	rm -f subprojects/*.wrap
}

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libadapta-1.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
