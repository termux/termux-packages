TERMUX_PKG_HOMEPAGE=http://www.xvid.org/
TERMUX_PKG_DESCRIPTION="High performance and high quality MPEG-4 library"
TERMUX_PKG_VERSION=1.3.3
TERMUX_PKG_SRCURL=http://downloads.xvid.org/downloads/xvidcore-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=xvidcore

TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	export TERMUX_PKG_BUILDDIR=$TERMUX_PKG_BUILDDIR/build/generic
	export TERMUX_PKG_SRCDIR=$TERMUX_PKG_BUILDDIR
}

