TERMUX_PKG_HOMEPAGE=https://notcurses.com/
TERMUX_PKG_DESCRIPTION="blingful TUIs and character graphics"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.8
TERMUX_PKG_SRCURL=https://github.com/dankamongmen/notcurses/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=56c33ffe2a2bc4d0b6e3ac14bdf620cf41e3293789135f76825057d0166974fd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ffmpeg, libandroid-spawn, libc++, libunistring, ncurses, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_DOCTEST=OFF
-DUSE_DEFLATE=OFF
-DUSE_PANDOC=OFF
-DUSE_STATIC=OFF
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-spawn -lm"
}
