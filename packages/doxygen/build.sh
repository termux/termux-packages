TERMUX_PKG_HOMEPAGE=http://www.doxygen.org
TERMUX_PKG_DESCRIPTION="A documentation system for C++, C, Java, IDL and PHP"
TERMUX_PKG_VERSION=1.8.14
TERMUX_PKG_MAINTAINER="lokesh @hax4us"
TERMUX_PKG_SHA256=d1757e02755ef6f56fd45f1f4398598b920381948d6fcfa58f5ca6aa56f59d4d
TERMUX_PKG_SRCURL=http://ftp.stack.nl/pub/doxygen/doxygen-${TERMUX_PKG_VERSION}.src.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBISON_EXECUTABLE=`which bison`
-DCMAKE_BUILD_TYPE=Release
-DFLEX_EXECUTABLE=`which flex`
-DPYTHON_EXECUTABLE=`which python3`
-Dbuild_parse=yes
-Dbuild_xmlparser=yes
"
termux_step_post_make_install () {
	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/doxygen.1 $TERMUX_PREFIX/share/man/man1
}
