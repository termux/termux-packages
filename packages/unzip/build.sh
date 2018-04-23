TERMUX_PKG_HOMEPAGE=http://www.info-zip.org/
TERMUX_PKG_DESCRIPTION="Tools for working with zip files"
TERMUX_PKG_VERSION=6.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/infozip/unzip60.tar.gz
TERMUX_PKG_SHA256=036d96991646d0449ed0aa952e4fbe21b476ce994abc276e49d30e686708bd37
TERMUX_PKG_DEPENDS="libandroid-support, libbz2"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
	cp unix/Makefile Makefile
}

termux_step_make () {
	LD="$CC $LDFLAGS -lbz2" CC="$CC $CFLAGS $CPPFLAGS $LDFLAGS -DNO_LCHMOD -DUSE_BZIP2" make -j $TERMUX_MAKE_PROCESSES generic
}
