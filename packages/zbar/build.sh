TERMUX_PKG_HOMEPAGE=https://github.com/mchehab/zbar
TERMUX_PKG_DESCRIPTION="Software suite for reading bar codes from various sources"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.23.93"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/mchehab/zbar/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=212dfab527894b8bcbcc7cd1d43d63f5604a07473d31a5f02889e372614ebe28
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="imagemagick, libiconv, libjpeg-turbo"
TERMUX_PKG_BREAKS="zbar-dev"
TERMUX_PKG_REPLACES="zbar-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-pthread
--disable-video --without-xshm --without-xv
--without-x --without-gtk --without-qt
--without-python --mandir=$TERMUX_PREFIX/share/man"

termux_step_pre_configure() {
	autoreconf -vfi
}
