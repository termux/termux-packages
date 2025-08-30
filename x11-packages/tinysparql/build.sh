TERMUX_PKG_HOMEPAGE=https://gnome.pages.gitlab.gnome.org/tinysparql
TERMUX_PKG_DESCRIPTION="Low-footprint RDF triple store with SPARQL 1.1 interface"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.8.beta
TERMUX_PKG_SRCURL=https://github.com/GNOME/tinysparql/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=54779e1cec5a6d115a1ad3a3bf30858036842ea2d2b46e87065035a7239db64f
TERMUX_PKG_DEPENDS="libicu, dbus, pygobject, python, json-glib, libxml2, sqlite"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, icu-devtools, libsoup3, asciidoc, xorgproto, valac, gettext, libstemmer, binutils"
TERMUX_PKG_PYTHON_COMMON_DEPS="docutils, setuptools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocs=false
-Dbash_completion=false
-Dsystemd_user_services=false
-Dintrospection=disabled
-Dvapi=disabled
-Dtests=false
"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_meson
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
