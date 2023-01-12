TERMUX_PKG_HOMEPAGE=https://pygobject.readthedocs.io/
TERMUX_PKG_DESCRIPTION="Python package which provides bindings for GObject based libraries"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=3.42
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/pygobject/${_MAJOR_VERSION}/pygobject-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ade8695e2a7073849dd0316d31d8728e15e1e0bc71d9ff6d1c09e86be52bc957
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
