TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Libgee
TERMUX_PKG_DESCRIPTION="A collection library providing GObject-based interfaces and classes for commonly used data structures"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=0.20
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.6
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/libgee/${_MAJOR_VERSION}/libgee-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1bf834f5e10d60cc6124d74ed3c1dd38da646787fbf7872220b8b4068e476d4d
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
"

termux_step_pre_configure() {
	termux_setup_gir
}
