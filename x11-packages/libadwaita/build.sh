TERMUX_PKG_HOMEPAGE=https://gnome.pages.gitlab.gnome.org/libadwaita/
TERMUX_PKG_DESCRIPTION="Building blocks for modern adaptive GNOME applications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.3"
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/libadwaita/-/archive/${TERMUX_PKG_VERSION}/libadwaita-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7178fe8845a10cfbfd87e7dfb1541d1ce1a631bcc6bc3f39f09d3f946feb51e6
TERMUX_PKG_DEPENDS="appstream, fribidi, glib, graphene, gtk4, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=latest-regex
# libadwaita sometimes releases tags for older versions with newer tag dates.
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Dvapi=true
-Dtests=false
-Dexamples=true
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libadwaita-1.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
