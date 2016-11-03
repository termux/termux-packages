pkgname=libmpdclient
TERMUX_PKG_HOMEPAGE=http://www.musicpd.org/libs/libmpdclient/
TERMUX_PKG_DESCRIPTION="Asynchronous API library for interfacing MPD in the C, C++ & Objective C languages"
TERMUX_PKG_DEPENDS=""
_MAIN_VERSION=2
_PATCH_VERSION=10
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_SRCURL=https://www.musicpd.org/download/${pkgname}/${_MAIN_VERSION}/${pkgname}-${_MAIN_VERSION}.${_PATCH_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-documentation"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-default-socket=${TERMUX_PREFIX}/var/run/mpd/socket"
