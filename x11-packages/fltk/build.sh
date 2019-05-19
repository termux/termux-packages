TERMUX_PKG_HOMEPAGE=https://www.fltk.org/
TERMUX_PKG_DESCRIPTION="Graphical user interface toolkit for X"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.3.4.2
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://www.fltk.org/pub/fltk/${TERMUX_PKG_VERSION/.2/}/fltk-${TERMUX_PKG_VERSION/.2/-2}-source.tar.gz
TERMUX_PKG_SHA256=25d349c18c99508737d48f225a2eb26a43338f9247551cab72a317fa42cda910
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
