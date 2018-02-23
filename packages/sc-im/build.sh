TERMUX_PKG_HOMEPAGE=https://github.com/andmarti1424/sc-im
TERMUX_PKG_DESCRIPTION="An improved version of sc, a spreadsheet calculator"
TERMUX_PKG_DEPENDS="ncurses, ndk-sysroot"
TERMUX_PKG_SHA256=87225918cb6f52bbc068ee6b12eaf176c7c55ba9739b29ca08cb9b6699141cad
TERMUX_PKG_VERSION=0.7.0
TERMUX_PKG_SRCURL=https://github.com/andmarti1424/sc-im/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_configure () {
	cp -rf src/* .
	CFLAGS+=" $CPPFLAGS -I$TERMUX_PREFIX/include/libandroid-support"
}
