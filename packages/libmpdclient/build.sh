TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/libs/libmpdclient/
TERMUX_PKG_DESCRIPTION="Asynchronous API library for interfacing MPD in the C, C++ & Objective C languages"
TERMUX_PKG_MAINTAINER="Matthew Klein @mklein994"
TERMUX_PKG_VERSION=2.15
TERMUX_PKG_SHA256=dd3d36801e397bf43719a291289ff610af71859c08f3196a506e4b1af43c290c
TERMUX_PKG_SRCURL=https://github.com/MusicPlayerDaemon/libmpdclient/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -D default_socket==${TERMUX_PREFIX}/var/run/mpd/socket"
