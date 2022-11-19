TERMUX_PKG_HOMEPAGE=http://openscad.org/
TERMUX_PKG_DESCRIPTION="The programmers solid 3D CAD modeller (headless build)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2019.05
TERMUX_PKG_REVISION=10
TERMUX_PKG_SRCURL=https://files.openscad.org/openscad-$TERMUX_PKG_VERSION.src.tar.gz
TERMUX_PKG_SHA256=0a16c4263ce52380819dd91c609a719d38f12f6b8c4da0e828dcbe5b70996f59
TERMUX_PKG_DEPENDS="boost, double-conversion, fontconfig, freetype, glib, harfbuzz, libc++, libgmp, libmpfr, libxml2, libzip"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, cgal, eigen"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBoost_USE_STATIC_LIBS=OFF
-DBUILD_SHARED_LIBS=ON
-DBUILD_STATIC_LIBS=OFF
-DNULLGL=ON
"

termux_step_make_install () {
	mkdir -p $TERMUX_PREFIX/share/openscad
	install openscad $TERMUX_PREFIX/bin/
	cp -r $TERMUX_PKG_SRCDIR/libraries $TERMUX_PREFIX/share/openscad/
	cp -r $TERMUX_PKG_SRCDIR/examples $TERMUX_PREFIX/share/openscad/
}
