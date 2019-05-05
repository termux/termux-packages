TERMUX_PKG_HOMEPAGE=http://zbar.sourceforge.net
TERMUX_PKG_DESCRIPTION="Software suite for reading bar codes from various sources"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=0.10
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/zbar/zbar/0.10/zbar-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=234efb39dbbe5cef4189cc76f37afbe3cfcfb45ae52493bfe8e191318bdbadc6
TERMUX_PKG_DEPENDS="libiconv, imagemagick, libjpeg-turbo, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-pthread
--disable-video --without-xshm --without-xv
--without-x --without-gtk --without-qt
--without-python --mandir=$TERMUX_PREFIX/share/man"

termux_step_pre_configure() {
	autoconf
}
