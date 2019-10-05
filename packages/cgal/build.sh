TERMUX_PKG_HOMEPAGE=https://www.cgal.org/
TERMUX_PKG_DESCRIPTION="Computational Geometry Algorithms Library"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_VERSION=4.14.1
TERMUX_PKG_SRCURL=https://github.com/CGAL/cgal/archive/releases/CGAL-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4b0d20d2bfee8cf9b622e5966451fa91b3c01109f7bd507829eaee5e78cc3f04
TERMUX_PKG_DEPENDS="boost, libc++, libgmp, libmpfr, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_CGAL_Qt5=OFF
-DWITH_demos=OFF
-DWITH_examples=OFF
-DWITH_tests=OFF
"
