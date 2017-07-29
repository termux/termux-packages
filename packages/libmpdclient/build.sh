TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/libs/libmpdclient/
TERMUX_PKG_DESCRIPTION="Asynchronous API library for interfacing MPD in the C, C++ & Objective C languages"
TERMUX_PKG_MAINTAINER="Matthew Klein @mklein994"
_MAIN_VERSION=2
_PATCH_VERSION=13
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_SHA256=5115bd52bc20a707c1ecc7587e6389c17305348e2132a66cf767c62fc55ed45d
TERMUX_PKG_SRCURL=https://www.musicpd.org/download/libmpdclient/${_MAIN_VERSION}/libmpdclient-${_MAIN_VERSION}.${_PATCH_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -D default_socket==${TERMUX_PREFIX}/var/run/mpd/socket"
