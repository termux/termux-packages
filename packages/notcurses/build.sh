TERMUX_PKG_HOMEPAGE=https://notcurses.com/
TERMUX_PKG_DESCRIPTION="blingful TUIs and character graphics"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.13"
TERMUX_PKG_SRCURL=https://github.com/dankamongmen/notcurses/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cf6342e50c02b830869bd28d8c953d22316b942b671e833c0f36899502084b35
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
