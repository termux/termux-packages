TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/libs/libmpdclient/
TERMUX_PKG_DESCRIPTION="Asynchronous API library for interfacing MPD in the C, C++ & Objective C languages"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.20
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/MusicPlayerDaemon/libmpdclient/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3c5a671e7bc5736c677ef75017eaf008e8838ac03605953410e8d4de6b363b73
TERMUX_PKG_BREAKS="libmpdclient-dev"
TERMUX_PKG_REPLACES="libmpdclient-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Ddefault_socket=${TERMUX_PREFIX}/var/run/mpd.socket"
