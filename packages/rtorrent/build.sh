TERMUX_PKG_HOMEPAGE=https://rakshasa.github.io/rtorrent/
TERMUX_PKG_DESCRIPTION="Ncurses BitTorrent client based on libTorrent"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.16.10"
TERMUX_PKG_SRCURL=https://github.com/rakshasa/rtorrent/releases/download/v${TERMUX_PKG_VERSION}/rtorrent-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ee3cbd8ee95d98b266f6dbef56ce6b566d340955c762dc4c407f45b706ff5733
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libcurl, libtorrent, libxmlrpc, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-xmlrpc-c
"
