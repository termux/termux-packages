TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/GtkSourceView
TERMUX_PKG_DESCRIPTION="A GNOME library that extends GtkTextView"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.8
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gtksourceview/${_MAJOR_VERSION}/gtksourceview-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7ec9d18fb283d1f84a3a3eff3b7a72b09a10c9c006597b3fbabbb5958420a87d
TERMUX_PKG_DEPENDS="atk, fribidi, glib, gtk3, libcairo, libxml2, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgir=true
-Dvapi=false
"

termux_step_pre_configure() {
	termux_setup_gir
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libgtksourceview-4.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
