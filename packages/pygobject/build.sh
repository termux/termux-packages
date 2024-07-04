TERMUX_PKG_HOMEPAGE=https://pygobject.readthedocs.io/
TERMUX_PKG_DESCRIPTION="Python package which provides bindings for GObject based libraries"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.48.2"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/pygobject/${TERMUX_PKG_VERSION%.*}/pygobject-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0794aeb4a9be31a092ac20621b5f54ec280f9185943d328b105cdae6298ad1a7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gobject-introspection, libcairo, libffi, pycairo, python"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dpycairo=enabled
-Dtests=false
"

termux_step_pre_configure() {
	TERMUX_PKG_VERSION=. termux_setup_gir
}
