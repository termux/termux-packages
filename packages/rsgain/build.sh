TERMUX_PKG_HOMEPAGE=https://github.com/complexlogic/rsgain
TERMUX_PKG_DESCRIPTION="A simple audio normalizazion utility"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="3.5.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/complexlogic/rsgain/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4288ecec00b0d907af86779b38874a2c4dcd67005f1b7fe09f6767ac5dc8e7a6
TERMUX_PKG_DEPENDS='taglib, libc++, libinih, libebur128, ffmpeg'
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DUSE_STD_FORMAT=ON"
