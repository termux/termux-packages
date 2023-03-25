TERMUX_PKG_HOMEPAGE=https://pygobject.readthedocs.io/
TERMUX_PKG_DESCRIPTION="Python package which provides bindings for GObject based libraries"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=3.44
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/pygobject/${_MAJOR_VERSION}/pygobject-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3c6805d1321be90cc32e648215a562430e0d3d6edcda8f4c5e7a9daffcad5710
TERMUX_PKG_DEPENDS="glib, gobject-introspection, libcairo, libffi, pycairo, python"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dpycairo=enabled
-Dtests=false
"

termux_step_pre_configure() {
	termux_setup_gir
}
