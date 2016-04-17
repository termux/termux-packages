TERMUX_PKG_HOMEPAGE=http://zbar.sourceforge.net
TERMUX_PKG_DESCRIPTION="Software suite for reading bar codes from various sources"
TERMUX_PKG_VERSION=0.10
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/zbar/zbar/0.10/zbar-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="imagemagick"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-pthread --disable-video --without-xshm --without-xv --without-gtk --without-qt --without-python --mandir=$TERMUX_PREFIX/share/man"
