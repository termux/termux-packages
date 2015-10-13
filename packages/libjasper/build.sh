TERMUX_PKG_HOMEPAGE=http://www.ece.uvic.ca/~frodo/jasper/
TERMUX_PKG_DESCRIPTION="Library for manipulating JPEG-2000 files"
TERMUX_PKG_VERSION=1.900.1
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://www.ece.uvic.ca/~frodo/jasper/software/jasper-${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_DEPENDS="libjpeg-turbo"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=$TERMUX_PREFIX/share/man"
