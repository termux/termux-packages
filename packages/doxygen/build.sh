TERMUX_PKG_HOMEPAGE=http://www.doxygen.org
TERMUX_PKG_DESCRIPTION="A documentation system for C++, C, Java, IDL and PHP"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.8.18
TERMUX_PKG_SRCURL=https://github.com/doxygen/doxygen/archive/Release_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=9c88f733396dca16139483045d5afa5bbf19d67be0b8f0ea43c4e813ecfb2aa2
TERMUX_PKG_DEPENDS="libc++, libiconv"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBISON_EXECUTABLE=$(which bison)
-DCMAKE_BUILD_TYPE=Release
-DFLEX_EXECUTABLE=$(which flex)
-DPYTHON_EXECUTABLE=$(which python3)
-Dbuild_parse=yes
-Dbuild_xmlparser=yes
"

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/doxygen.1 $TERMUX_PREFIX/share/man/man1
}
