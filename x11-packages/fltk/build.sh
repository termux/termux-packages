TERMUX_PKG_HOMEPAGE=https://www.fltk.org/
TERMUX_PKG_DESCRIPTION="Graphical user interface toolkit for X"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.8
TERMUX_PKG_SRCURL=https://www.fltk.org/pub/fltk/${TERMUX_PKG_VERSION}/fltk-${TERMUX_PKG_VERSION}-source.tar.gz
TERMUX_PKG_SHA256=f3c1102b07eb0e7a50538f9fc9037c18387165bc70d4b626e94ab725b9d4d1bf
TERMUX_PKG_DEPENDS="fontconfig, glu, libc++, libjpeg-turbo, libpng, libx11, libxcursor, libxext, libxfixes, libxft, libxinerama, libxrender, opengl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-shared
--enable-threads
--enable-xinerama
--enable-xft
--enable-xfixes
--enable-xcursor
--enable-xrender
"

termux_step_pre_configure() {
	sed -i 's/class Fl_XFont_On_Demand/class FL_EXPORT Fl_XFont_On_Demand/' FL/x.H
	sed -i 's/x-fluid.desktop/fluid.desktop/' -i fluid/Makefile
	sed -i -e 's/$(LINKFLTK)/$(LINKSHARED)/' -e 's/$(LINKFLTKIMG)/$(LINKSHARED)/' test/Makefile

	export LIBS="$LDFLAGS"
}
