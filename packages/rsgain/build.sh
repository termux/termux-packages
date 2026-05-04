TERMUX_PKG_HOMEPAGE=https://github.com/complexlogic/rsgain
TERMUX_PKG_DESCRIPTION="A simple audio normalizazion utility"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="3.7"
TERMUX_PKG_SRCURL=https://github.com/complexlogic/rsgain/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ef383af1adbc01a6e858b45b67b632168ef7c1ee8c2f8267630cbd0f9bf8498e
TERMUX_PKG_DEPENDS='taglib, libc++, libinih, libebur128, ffmpeg'
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DUSE_STD_FORMAT=ON"
