TERMUX_PKG_HOMEPAGE=https://github.com/complexlogic/rsgain
TERMUX_PKG_DESCRIPTION="A simple audio normalizazion utility"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="3.6"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/complexlogic/rsgain/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=26f7acd1ba0851929dc756c93b3b1a6d66d7f2f36b31f744c8181f14d7b5c8a7
TERMUX_PKG_DEPENDS='taglib, libc++, libinih, libebur128, ffmpeg'
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DUSE_STD_FORMAT=ON"
