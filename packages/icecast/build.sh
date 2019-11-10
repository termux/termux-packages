TERMUX_PKG_HOMEPAGE=https://icecast.org
TERMUX_PKG_DESCRIPTION="Icecast is a streaming media (audio/video) server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.4.4
TERMUX_PKG_SRCURL=https://downloads.xiph.org/releases/icecast/icecast-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=49b5979f9f614140b6a38046154203ee28218d8fc549888596a683ad604e4d44
TERMUX_PKG_DEPENDS="libcurl, libgnutls, libogg, libvorbis, libxml2, libxslt, mime-support, openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
    perl -p -i -e "s#/etc/mime.types#$TERMUX_PREFIX/etc/mime.types#" $TERMUX_PKG_SRCDIR/src/cfgfile.c
}
