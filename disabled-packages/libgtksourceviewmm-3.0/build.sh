TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/GtkSourceView
TERMUX_PKG_DESCRIPTION="C++ binding for gtksourceview"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=3.21
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.3
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gtksourceviewmm/${_MAJOR_VERSION}/gtksourceviewmm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=dbb00b1c28e0407cc27d8b07a2ed0b4ea22f92e4b3e3006431cbd6726b6256b5
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, gtkmm3, gtksourceview3, harfbuzz, libatkmm-1.6, libc++, libcairo, libcairomm-1.0, libglibmm-2.4, libpangomm-1.4, libsigc++-2.0, pango, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-documentation
"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
