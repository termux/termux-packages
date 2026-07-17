TERMUX_PKG_HOMEPAGE=https://rakshasa.github.io/rtorrent/
TERMUX_PKG_DESCRIPTION="Ncurses BitTorrent client based on libTorrent"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.16.18"
TERMUX_PKG_SRCURL=https://github.com/rakshasa/rtorrent/releases/download/v${TERMUX_PKG_VERSION}/rtorrent-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0c7d4902cc914fabe984284330333c7b82aec9951c55915712cdd10acaae65cb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn, libc++, libcurl, libtorrent, libxmlrpc, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-xmlrpc-c
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-spawn"
}
