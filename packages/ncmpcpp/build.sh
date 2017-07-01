TERMUX_PKG_HOMEPAGE=https://rybczak.net/ncmpcpp/
TERMUX_PKG_DESCRIPTION="NCurses Music Player Client (Plus Plus)"
TERMUX_PKG_VERSION=0.8
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://rybczak.net/ncmpcpp/stable/ncmpcpp-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=2f0f2a1c0816119430880be6932e5eb356b7875dfa140e2453a5a802909f465a
TERMUX_PKG_DEPENDS="fftw, boost, readline, libcurl, libmpdclient"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_KEEP_SHARE_DOC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-visualizer --enable-outputs --enable-clock"

termux_step_pre_configure() { 
	./autogen.sh
	CXXFLAGS+=" -DNCURSES_WIDECHAR -U_XOPEN_SOURCE"
}
