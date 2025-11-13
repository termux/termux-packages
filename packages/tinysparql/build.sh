TERMUX_PKG_HOMEPAGE=https://gnome.pages.gitlab.gnome.org/tinysparql
TERMUX_PKG_DESCRIPTION="Desktop-neutral metadata-based search framework"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.9.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/GNOME/tinysparql/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=387fc277889f64e2beea7ac5be2532e937c803e216fcf949ab4e4d96f9726d62
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
-Doverride_sqlite_version_check=true
"
# Temporary - remove after the merge of https://github.com/termux/termux-packages/pull/23652
TERMUX_PKG_RM_AFTER_INSTALL="lib/python$TERMUX_PYTHON_VERSION/site-packages/asciidoc/__pycache__"

termux_step_post_get_source() {
	rm -f subprojects/*.wrap
}

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
