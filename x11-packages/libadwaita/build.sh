TERMUX_PKG_HOMEPAGE=https://gnome.pages.gitlab.gnome.org/libadwaita/
TERMUX_PKG_DESCRIPTION="Building blocks for modern adaptive GNOME applications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.2
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libadwaita/${_MAJOR_VERSION}/libadwaita-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=322f3e1be39ba67981d9fe7228a85818eccaa2ed0aa42bcafe263af881c6460c
TERMUX_PKG_DEPENDS="fribidi, glib, graphene, gtk4, libcairo, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Dvapi=true
-Dtests=false
-Dexamples=false
"

termux_step_pre_configure() {
	termux_setup_gir
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libadwaita-1.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
