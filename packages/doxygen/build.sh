TERMUX_PKG_HOMEPAGE=http://www.doxygen.org
TERMUX_PKG_DESCRIPTION="A documentation system for C++, C, Java, IDL and PHP"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="lokesh @hax4us"
TERMUX_PKG_VERSION=1.8.15
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=bd9c0ec462b6a9b5b41ede97bede5458e0d7bb40d4cfa27f6f622eb33c59245d
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/doxygen-$TERMUX_PKG_VERSION.src.tar.gz
TERMUX_PKG_DEPENDS="libiconv"

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
