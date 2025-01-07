# x11-packages
TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/pypanel/
TERMUX_PKG_DESCRIPTION="A lightweight panel/taskbar for X11 window managers written in python."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.4
TERMUX_PKG_REVISION=35
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/pypanel/PyPanel-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4e612b43c61b3a8af7d57a0364f6cd89df481dc41e20728afa643e9e3546e911
TERMUX_PKG_DEPENDS="freetype, imlib2, libx11, libxft, python2, python2-xlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/pypanelrc"

termux_step_make() {
	"${CC}" -DNDEBUG \
			-fwrapv \
			-Wall \
			-Wstrict-prototypes \
			-fno-strict-aliasing \
			-Oz \
			-fPIC \
			-DHAVE_XFT=1 \
			-DIMLIB2_FIX=1 \
			-I$TERMUX_PREFIX/include \
			-I$TERMUX_PREFIX/include/freetype2 \
			-I$TERMUX_PREFIX/include/libpng16 \
			-c ppmodule.c \
			-o ppmodule.o \

	"${CC}" -shared \
			ppmodule.o \
			$LDFLAGS \
			-lfreetype \
			-lXft \
			-lImlib2 \
			-lpython2.7 \
			-lX11 \
			-o ppmodule.so
}

termux_step_make_install() {
	mkdir -p "${TERMUX_PREFIX}/bin"
	cp -f pypanel "${TERMUX_PREFIX}/bin/pypanel"
	chmod 755 "${TERMUX_PREFIX}/bin/pypanel"

	mkdir -p "${TERMUX_PREFIX}/etc"
	cp -f pypanelrc "${TERMUX_PREFIX}/etc/pypanelrc"
	chmod 644 "${TERMUX_PREFIX}/etc/pypanelrc"

	mkdir -p "${TERMUX_PREFIX}/lib/python2.7/site-packages"
	cp ppmodule.so "${TERMUX_PREFIX}/lib/python2.7/site-packages/ppmodule.so"
	chmod 644 "${TERMUX_PREFIX}/lib/python2.7/site-packages/ppmodule.so"

	mkdir -p "${TERMUX_PREFIX}/lib/python2.7/site-packages/pypanel"
	cp -f COPYING README pypanelrc ppicon.png "${TERMUX_PREFIX}/lib/python2.7/site-packages/pypanel/"
	chmod 644 ${TERMUX_PREFIX}/lib/python2.7/site-packages/pypanel/*
}
