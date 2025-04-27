TERMUX_PKG_HOMEPAGE=https://notcurses.com/
TERMUX_PKG_DESCRIPTION="blingful TUIs and character graphics"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.14"
TERMUX_PKG_SRCURL=https://github.com/dankamongmen/notcurses/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=45afdda09d64c4a8bf2fc261dbbe5fa3784df6eff23a994778b234ee1d6fb30b
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
