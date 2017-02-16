TERMUX_PKG_HOMEPAGE=http://icecast.org
TERMUX_PKG_DESCRIPTION="Icecast is a streaming media (audio/video) server"
TERMUX_PKG_VERSION=2.4.3
TERMUX_PKG_SRCURL=http://downloads.xiph.org/releases/icecast/icecast-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libcurl, libgnutls, libogg, libvorbis, libxml2, libxslt, openssl"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
    perl -p -i -e "s#/etc/mime.types#$TERMUX_PREFIX/etc/mime.types#" $TERMUX_PKG_SRCDIR/src/cfgfile.c
}