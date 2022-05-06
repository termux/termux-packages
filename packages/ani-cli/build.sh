TERMUX_PKG_HOMEPAGE=https://github.com/pystardust/ani-cli
TERMUX_PKG_DESCRIPTION="A cli to browse and watch anime"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2
TERMUX_PKG_SRCURL=https://github.com/pystardust/ani-cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=973d335a75bd7f920c244000ad6b057f702fb37752e7bea1b5bcf038785ec925
TERMUX_PKG_DEPENDS="aria2, curl, grep, mpv, openssl-tool, sed, gawk, ffmpeg"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin ani-cli
}
