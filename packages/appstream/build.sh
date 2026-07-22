TERMUX_PKG_HOMEPAGE="https://www.freedesktop.org/wiki/Distributions/AppStream/"
TERMUX_PKG_DESCRIPTION="Provides a standard for creating app stores across distributions"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.4"
TERMUX_PKG_SRCURL=https://github.com/ximion/appstream/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0cba35762201ab9e367d5b8da4d0a6c3bd456103ac78b852585995318d6f109a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="curl, glib, libfyaml, libxml2, libxmlb, zstd"
TERMUX_PKG_BUILD_DEPENDS="bash-completion, g-ir-scanner, glib-cross, libwayland, valac"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dapidocs=false
-Ddocs=false
-Dgir=true
-Dstemming=false
-Dsystemd=false
-Dvapi=true
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
