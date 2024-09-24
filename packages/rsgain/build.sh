TERMUX_PKG_HOMEPAGE=https://github.com/complexlogic/rsgain
TERMUX_PKG_DESCRIPTION="A simple audio normalizazion utility"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="3.5.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/complexlogic/rsgain/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c76ba0dfaafcaa3ceb71a3e5a1de128200d92f7895d8c2ad45360adefe5a103b
TERMUX_PKG_DEPENDS='taglib, libc++, libinih, libebur128, ffmpeg'
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DUSE_STD_FORMAT=ON"
