TERMUX_PKG_HOMEPAGE=https://github.com/mchehab/zbar
TERMUX_PKG_DESCRIPTION="Software suite for reading bar codes from various sources"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.23.1
TERMUX_PKG_SRCURL=https://github.com/mchehab/zbar/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=297439f8859089d2248f55ab95b2a90bba35687975365385c87364c77fdb19f3
TERMUX_PKG_DEPENDS="libiconv, imagemagick, libjpeg-turbo, zlib"
TERMUX_PKG_BREAKS="zbar-dev"
TERMUX_PKG_REPLACES="zbar-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-pthread
--disable-video --without-xshm --without-xv
--without-x --without-gtk --without-qt
--without-python --mandir=$TERMUX_PREFIX/share/man"

termux_step_pre_configure() {
	autoreconf -vfi
}
