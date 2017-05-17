TERMUX_PKG_HOMEPAGE=https://rybczak.net/ncmpcpp/
TERMUX_PKG_DESCRIPTION="NCurses Music Player Client (Plus Plus)"
TERMUX_PKG_VERSION=0.7.7
local _COMMIT=8134e6e23b2787322fa10e65e44d286da82eea91
TERMUX_PKG_SRCURL=https://github.com/arybczak/ncmpcpp/archive/${_COMMIT}.zip
TERMUX_PKG_FOLDERNAME="ncmpcpp-$_COMMIT"
TERMUX_PKG_SHA256=aced88b623ef79f6ccf619f769e7f4b6680d395aef9a789cee6d019927577c62
TERMUX_PKG_DEPENDS="fftw, boost, readline, libcurl, libmpdclient"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_KEEP_SHARE_DOC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-visualizer --enable-outputs --enable-clock"

termux_step_pre_configure() { 
	./autogen.sh
	CXXFLAGS+=" -DNCURSES_WIDECHAR -U_XOPEN_SOURCE"
}
