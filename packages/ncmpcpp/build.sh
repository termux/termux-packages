TERMUX_PKG_HOMEPAGE=https://rybczak.net/ncmpcpp/
TERMUX_PKG_DESCRIPTION="NCurses Music Player Client (Plus Plus)"
TERMUX_PKG_VERSION=0.8.1
TERMUX_PKG_SHA256=4df9570a1db4ba2dc9b759aab88b283c00806fb5d2bce5f5d27a2eb10e6888ff
TERMUX_PKG_SRCURL=https://rybczak.net/ncmpcpp/stable/ncmpcpp-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="fftw, boost, readline, libcurl, libmpdclient, ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_KEEP_SHARE_DOC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-visualizer --enable-outputs --enable-clock"

termux_step_pre_configure() {
	./autogen.sh
	CXXFLAGS+=" -DNCURSES_WIDECHAR -U_XOPEN_SOURCE"
}
