TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/libs/libmpdclient/
TERMUX_PKG_DESCRIPTION="Asynchronous API library for interfacing MPD in the C, C++ & Objective C languages"
TERMUX_PKG_MAINTAINER="Matthew Klein @mklein994"
_MAIN_VERSION=2
_PATCH_VERSION=14
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_SHA256=0a84e2791bfe3077cf22ee1784c805d5bb550803dffe56a39aa3690a38061372
TERMUX_PKG_SRCURL=https://www.musicpd.org/download/libmpdclient/${_MAIN_VERSION}/libmpdclient-${_MAIN_VERSION}.${_PATCH_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -D default_socket==${TERMUX_PREFIX}/var/run/mpd/socket"
