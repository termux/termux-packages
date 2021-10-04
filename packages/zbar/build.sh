TERMUX_PKG_HOMEPAGE=https://github.com/mchehab/zbar
TERMUX_PKG_DESCRIPTION="Software suite for reading bar codes from various sources"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.23.90
TERMUX_PKG_SRCURL=https://github.com/mchehab/zbar/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=25fdd6726d5c4c6f95c95d37591bfbb2dde63d13d0b10cb1350923ea8b11963b
TERMUX_PKG_AUTO_UPDATE=true
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
