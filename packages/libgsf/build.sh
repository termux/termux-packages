TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libgsf
TERMUX_PKG_DESCRIPTION="The G Structured File Library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.14
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.49
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libgsf/${_MAJOR_VERSION}/libgsf-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e9ebe36688f010c9e6e40c8903f3732948deb8aca032578d07d0751bd82cf857
TERMUX_PKG_DEPENDS="glib, libbz2, libxml2, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-introspection
--with-bz2
--without-gdk-pixbuf
"
