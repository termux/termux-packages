TERMUX_PKG_HOMEPAGE=https://djvu.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Suite to create, manipulate and view DjVu ('déjà vu') documents"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5.28
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/djvu/djvulibre-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fcd009ea7654fde5a83600eb80757bd3a76998e47d13c66b54c8db849f8f2edc
TERMUX_PKG_DEPENDS="libc++, libjpeg-turbo, libtiff"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
