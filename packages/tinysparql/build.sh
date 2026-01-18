TERMUX_PKG_HOMEPAGE=https://gnome.pages.gitlab.gnome.org/tinysparql
TERMUX_PKG_DESCRIPTION="Desktop-neutral metadata-based search framework"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.10.1"
TERMUX_PKG_SRCURL="https://github.com/GNOME/tinysparql/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=37a987a4b59dd20b671eb21791a8d37d3c6d1172906f70edcee7889547986956
TERMUX_PKG_DEPENDS="libicu, dbus, pygobject, python, json-glib, libxml2, sqlite"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, icu-devtools, libsoup3, asciidoc, xorgproto, valac, gettext, libstemmer, binutils"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="docutils, setuptools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocs=false
-Dbash_completion=false
-Dsystemd_user_services=false
-Dintrospection=disabled
-Dvapi=disabled
-Dtests=false
-Doverride_sqlite_version_check=true
"

termux_step_post_get_source() {
	rm -f subprojects/*.wrap
}

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
