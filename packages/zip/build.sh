TERMUX_PKG_VERSION=3.0
TERMUX_PKG_HOMEPAGE=http://www.info-zip.org/
TERMUX_PKG_DESCRIPTION="Tools for working with zip files"
TERMUX_PKG_SRCURL="http://heanet.dl.sourceforge.net/project/infozip/Zip%203.x%20%28latest%29/3.0/zip30.tar.gz"
TERMUX_PKG_DEPENDS="libandroid-support,bzip2"
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
