TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://www.fltk.org/
TERMUX_PKG_DESCRIPTION="Graphical user interface toolkit for X"
TERMUX_PKG_VERSION=1.3.4
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=http://fltk.org/pub/fltk/${TERMUX_PKG_VERSION}/fltk-${TERMUX_PKG_VERSION}-source.tar.gz
TERMUX_PKG_SHA256=c8ab01c4e860d53e11d40dc28f98d2fe9c85aaf6dbb5af50fd6e66afec3dc58f
TERMUX_PKG_DEPENDS="libc++, libjpeg-turbo, libxcursor, libxfixes, libxft, libxinerama, libxrender"
TERMUX_PKG_REPLACES="fluid"
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

termux_step_pre_configure()
{
    sed -i 's/class Fl_XFont_On_Demand/class FL_EXPORT Fl_XFont_On_Demand/' FL/x.H
    sed -i 's/x-fluid.desktop/fluid.desktop/' -i fluid/Makefile
    sed -i -e 's/$(LINKFLTK)/$(LINKSHARED)/' -e 's/$(LINKFLTKIMG)/$(LINKSHARED)/' test/Makefile

    export LIBS="-L/data/data/com.termux/files/usr/lib"
}
