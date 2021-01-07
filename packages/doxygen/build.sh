TERMUX_PKG_HOMEPAGE=http://www.doxygen.org
TERMUX_PKG_DESCRIPTION="A documentation system for C++, C, Java, IDL and PHP"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.0
TERMUX_PKG_SRCURL=https://github.com/doxygen/doxygen/archive/Release_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=91b81141b7eeb251ca8069c114efa45e15614bcb9d7121fac4f3e9da592c56ab
TERMUX_PKG_DEPENDS="libc++, libiconv"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBISON_EXECUTABLE=$(command -v bison)
-DCMAKE_BUILD_TYPE=Release
-DFLEX_EXECUTABLE=$(command -v flex)
-DPYTHON_EXECUTABLE=$(command -v python3)
-Dbuild_parse=yes
-Dbuild_xmlparser=yes
"

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/doxygen.1 $TERMUX_PREFIX/share/man/man1
}
