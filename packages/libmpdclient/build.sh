TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/libs/libmpdclient/
TERMUX_PKG_DESCRIPTION="Asynchronous API library for interfacing MPD in the C, C++ & Objective C languages"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.21"
TERMUX_PKG_SRCURL=https://github.com/MusicPlayerDaemon/libmpdclient/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=67a37939426f3b8e6b1e4f7391c5f96301635ffa681d28ea83b4c63b11818f63
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_BREAKS="libmpdclient-dev"
TERMUX_PKG_REPLACES="libmpdclient-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Ddefault_socket=${TERMUX_PREFIX}/var/run/mpd.socket"
