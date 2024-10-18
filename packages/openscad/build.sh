TERMUX_PKG_HOMEPAGE=https://openscad.org/
TERMUX_PKG_DESCRIPTION="The programmers solid 3D CAD modeller (headless build)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2021.01
TERMUX_PKG_SRCURL=https://files.openscad.org/openscad-$TERMUX_PKG_VERSION.src.tar.gz
TERMUX_PKG_SHA256=d938c297e7e5f65dbab1461cac472fc60dfeaa4999ea2c19b31a4184f2d70359
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
