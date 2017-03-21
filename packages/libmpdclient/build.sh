TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/libs/libmpdclient/
TERMUX_PKG_DESCRIPTION="Asynchronous API library for interfacing MPD in the C, C++ & Objective C languages"
TERMUX_PKG_MAINTAINER="Matthew Klein @mklein994"
_MAIN_VERSION=2
_PATCH_VERSION=11
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_SRCURL=https://www.musicpd.org/download/libmpdclient/${_MAIN_VERSION}/libmpdclient-${_MAIN_VERSION}.${_PATCH_VERSION}.tar.xz
TERMUX_PKG_SHA256=15fe693893c0d7ea3f4c35c4016fbd0332836164178b20983eec9b470846baf6
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-documentation"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-default-socket=${TERMUX_PREFIX}/var/run/mpd/socket"
