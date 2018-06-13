TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/libs/libmpdclient/
TERMUX_PKG_DESCRIPTION="Asynchronous API library for interfacing MPD in the C, C++ & Objective C languages"
TERMUX_PKG_MAINTAINER="Matthew Klein @mklein994"
TERMUX_PKG_VERSION=2.14
TERMUX_PKG_SHA256=262f1ff13e6ee11cca2ef93f2eda10ec6953a7b8e628572645e707fe530fbbb6
TERMUX_PKG_SRCURL=https://github.com/MusicPlayerDaemon/libmpdclient/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -D default_socket==${TERMUX_PREFIX}/var/run/mpd/socket"
