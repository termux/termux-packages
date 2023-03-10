TERMUX_PKG_HOMEPAGE=https://github.com/mchehab/zbar
TERMUX_PKG_DESCRIPTION="Software suite for reading bar codes from various sources"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.23.92
TERMUX_PKG_SRCURL=https://github.com/mchehab/zbar/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dffc16695cb6e42fa318a4946fd42866c0f5ab735f7eaf450b108d1c3a19b4ba
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
