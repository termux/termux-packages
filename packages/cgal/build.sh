TERMUX_PKG_HOMEPAGE=https://www.cgal.org/
TERMUX_PKG_DESCRIPTION="Computational Geometry Algorithms Library"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_VERSION=5.0.3
TERMUX_PKG_SRCURL=https://github.com/CGAL/cgal/archive/releases/CGAL-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=30194b3169ed9161806eea40bdabd54067e2b7a1e2bf6be1aa8d6c9f1eda5531
TERMUX_PKG_DEPENDS="boost, libc++, libgmp, libmpfr, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_CGAL_Qt5=OFF
-DWITH_demos=OFF
-DWITH_examples=OFF
-DWITH_tests=OFF
"
