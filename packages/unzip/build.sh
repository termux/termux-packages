TERMUX_PKG_VERSION=6.0
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_HOMEPAGE=http://www.info-zip.org/
TERMUX_PKG_DESCRIPTION="Tools for working with zip files"
TERMUX_PKG_SRCURL="http://downloads.sourceforge.net/project/infozip/UnZip%206.x%20%28latest%29/UnZip%206.0/unzip60.tar.gz"
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
	cp unix/Makefile Makefile
}

termux_step_make () {
	prefix=$TERMUX_PREFIX LD="$CC $LDFLAGS" CC="$CC $CFLAGS $CPPFLAGS $LDFLAGS" PREFIX=$TERMUX_PREFIX make -j $TERMUX_MAKE_PROCESSES generic
}

termux_step_make_install () {
	prefix=$TERMUX_PREFIX make install
}
