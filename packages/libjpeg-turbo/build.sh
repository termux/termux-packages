TERMUX_PKG_HOMEPAGE=http://libjpeg-turbo.virtualgl.org/
TERMUX_PKG_DESCRIPTION="Library for reading and writing JPEG image files"
TERMUX_PKG_VERSION=1.4.0
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/libjpeg-turbo/${TERMUX_PKG_VERSION}/libjpeg-turbo-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=$TERMUX_PREFIX/share/man"
#TERMUX_PKG_FOLDERNAME=jpeg-9a
#TERMUX_PKG_RM_AFTER_INSTALL="bin/cjpeg bin/djpeg bin/jpegtran bin/rdjpgcom bin/wrjpgcom share/man/man1/cjpeg.1 share/man/man1/djpeg.1 share/man/man1/jpegtran.1 share/man/man1/rdjpgcom.1 share/man/man1/wrjpgcom.1"

