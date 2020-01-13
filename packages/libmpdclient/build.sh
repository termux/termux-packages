TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/libs/libmpdclient/
TERMUX_PKG_DESCRIPTION="Asynchronous API library for interfacing MPD in the C, C++ & Objective C languages"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Matthew Klein @mklein994"
TERMUX_PKG_VERSION=2.17
TERMUX_PKG_SRCURL=https://github.com/MusicPlayerDaemon/libmpdclient/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=06eb4b67c63f64d647e97257ff5f8506bf9c2a26b314bf5d0dd5944995b59fc9
TERMUX_PKG_BREAKS="libmpdclient-dev"
TERMUX_PKG_REPLACES="libmpdclient-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -D default_socket==${TERMUX_PREFIX}/var/run/mpd/socket"
