TERMUX_PKG_HOMEPAGE=https://pygobject.gnome.org/
TERMUX_PKG_DESCRIPTION="Python package which provides bindings for GObject based libraries"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.56.2"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/pygobject/${TERMUX_PKG_VERSION%.*}/pygobject-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b816098969544081de9eecedb94ad6ac59c77e4d571fe7051f18bebcec074313
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gobject-introspection, libcairo, libffi, pycairo, python"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dpycairo=enabled
-Dtests=false
"

termux_step_pre_configure() {
	termux_setup_gir
}
