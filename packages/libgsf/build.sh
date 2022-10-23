TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libgsf
TERMUX_PKG_DESCRIPTION="The G Structured File Library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.14
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.50
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libgsf/${_MAJOR_VERSION}/libgsf-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6e6c20d0778339069d583c0d63759d297e817ea10d0d897ebbe965f16e2e8e52
TERMUX_PKG_DEPENDS="glib, libbz2, libxml2, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection
--with-bz2
--without-gdk-pixbuf
"

termux_step_pre_configure() {
	termux_setup_gir
}

termux_step_post_configure() {
	touch ./gsf/g-ir-scanner
}
