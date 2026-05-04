TERMUX_PKG_HOMEPAGE=https://icecast.org
TERMUX_PKG_DESCRIPTION="Icecast is a streaming media (audio/video) server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.5.0
TERMUX_PKG_SRCURL="https://downloads.xiph.org/releases/icecast/icecast-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=d9aa07c7429aec19d950ff6fd425c371f77158cd34ff220fc191b2c186c67c7a
TERMUX_PKG_DEPENDS="libcurl, libgnutls, libogg, libvorbis, libxml2, libxslt, media-types, openssl, libigloo"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology

termux_step_pre_configure() {
	perl -p -i -e "s#/etc/mime.types#$TERMUX_PREFIX/etc/mime.types#" $TERMUX_PKG_SRCDIR/src/cfgfile.c
}
