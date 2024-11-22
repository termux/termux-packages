TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/GtkSourceView
TERMUX_PKG_DESCRIPTION="A GNOME library that extends GtkTextView"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.14.2"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gtksourceview/${TERMUX_PKG_VERSION%.*}/gtksourceview-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1a6d387a68075f8aefd4e752cf487177c4a6823b14ff8a434986858aeaef6264
TERMUX_PKG_DEPENDS="fontconfig, fribidi, gdk-pixbuf, glib, gtk4, libcairo, libxml2, pango, pcre2"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbuild-testsuite=false
-Ddocumentation=false
-Dintrospection=enabled
-Dvapi=true
"

termux_step_pre_configure() {
	# Workaround strict compiler error
	sed -i "s/-Werror/-Wno-error/g" meson.build

	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libgtksourceview-5.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
