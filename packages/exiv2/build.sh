TERMUX_PKG_HOMEPAGE=http://www.exiv2.org
TERMUX_PKG_DESCRIPTION="Exiv2 is a Cross-platform C+( library and a command line utility to manage image metadata."
TERMUX_PKG_VERSION=0.26
TERMUX_PKG_DEPENDS="libexpat, libandroid-support"
TERMUX_PKG_SHA256=c75e3c4a0811bf700d92c82319373b7a825a2331c12b8b37d41eb58e4f18eafb
TERMUX_PKG_SRCURL=http://www.exiv2.org/builds/exiv2-${TERMUX_PKG_VERSION}-trunk.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --disable-nls"
TERMUX_PKG_BUILD_IN_SRC=yes
termux_step_pre_configure {
 patch -p0 configure $TERMUX_PKG_BUILDDIR/configure
 }
