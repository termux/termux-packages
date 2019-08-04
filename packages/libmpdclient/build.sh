TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/libs/libmpdclient/
TERMUX_PKG_DESCRIPTION="Asynchronous API library for interfacing MPD in the C, C++ & Objective C languages"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Matthew Klein @mklein994"
TERMUX_PKG_VERSION=2.16
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=6651898489b69d2f2f8e94f0ed6ddcc0dd2cdbcf99b02131b790551922558d6c
TERMUX_PKG_BREAKS="libmpdclient-dev"
TERMUX_PKG_REPLACES="libmpdclient-dev"
TERMUX_PKG_SRCURL=https://github.com/MusicPlayerDaemon/libmpdclient/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -D default_socket==${TERMUX_PREFIX}/var/run/mpd/socket"
