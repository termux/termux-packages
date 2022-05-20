TERMUX_PKG_HOMEPAGE=https://gnome.pages.gitlab.gnome.org/libadwaita/
TERMUX_PKG_DESCRIPTION="Building blocks for modern adaptive GNOME applications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.1
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libadwaita/${_MAJOR_VERSION}/libadwaita-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=491169d4f6a11765328996bc088272d05c7235453bc0ee73c20dfd4bd67b401c
TERMUX_PKG_DEPENDS="fribidi, glib, graphene, gtk4, libcairo, pango"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=disabled
-Dvapi=false
-Dtests=false
-Dexamples=false
"

termux_step_post_massage() {
	local _GUARD_FILE="lib/libadwaita-1.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
