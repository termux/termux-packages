TERMUX_PKG_HOMEPAGE=https://www.cgal.org/
TERMUX_PKG_DESCRIPTION="Computational Geometry Algorithms Library"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.3.1
TERMUX_PKG_SRCURL=https://github.com/CGAL/cgal/releases/download/v${TERMUX_PKG_VERSION}/CGAL-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ab76633b023d72ea3ca9ad22e2fa39ed3b5c8fb4e2c091a78035fabb5eb3fccf
TERMUX_PKG_DEPENDS="boost, libc++, libgmp, libmpfr, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_CGAL_Qt5=OFF
-DWITH_demos=OFF
-DWITH_examples=OFF
-DWITH_tests=OFF
"
