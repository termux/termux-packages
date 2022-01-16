TERMUX_PKG_HOMEPAGE=http://openil.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A cross-platform image library utilizing a simple syntax"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.8.0
TERMUX_PKG_SRCURL=https://github.com/DentonW/DevIL/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=52129f247b26fcb5554643c9e6bbee75c4b9717735fdbf3c6ebff08cee38ad37
TERMUX_PKG_DEPENDS="libc++, libjasper, libjpeg-turbo, libpng, libtiff, zlib"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/DevIL"
}
