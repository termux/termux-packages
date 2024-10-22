TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/GtkSourceView
TERMUX_PKG_DESCRIPTION="A GNOME library that extends GtkTextView"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.14.1"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gtksourceview/${TERMUX_PKG_VERSION%.*}/gtksourceview-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=009862e87b929da5a724ece079f01f8cee29e74797a1ecac349f58c15a3cbc58
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
