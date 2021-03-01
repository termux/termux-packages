TERMUX_PKG_HOMEPAGE=https://www.fltk.org/
TERMUX_PKG_DESCRIPTION="Graphical user interface toolkit for X"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.3.5
TERMUX_PKG_REVISION=17
TERMUX_PKG_SRCURL=https://www.fltk.org/pub/fltk/${TERMUX_PKG_VERSION}/fltk-${TERMUX_PKG_VERSION}-source.tar.gz
TERMUX_PKG_SHA256=8729b2a055f38c1636ba20f749de0853384c1d3e9d1a6b8d4d1305143e115702
TERMUX_PKG_DEPENDS="fontconfig, glu, libc++, libjpeg-turbo, libpng, libx11, libxcursor, libxext, libxfixes, libxft, libxinerama, libxrender, mesa, zlib"
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
