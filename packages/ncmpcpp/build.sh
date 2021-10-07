TERMUX_PKG_HOMEPAGE=https://rybczak.net/ncmpcpp/
TERMUX_PKG_DESCRIPTION="NCurses Music Player Client (Plus Plus)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.2
TERMUX_PKG_REVISION=18
TERMUX_PKG_SRCURL=https://rybczak.net/ncmpcpp/stable/ncmpcpp-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=650ba3e8089624b7ad9e4cc19bc1ac6028edb7523cc111fa1686ea44c0921554
TERMUX_PKG_DEPENDS="fftw, boost, readline, libandroid-support, libc++, libcurl, libmpdclient, ncurses, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-visualizer --enable-outputs --enable-clock"

termux_step_pre_configure() {
	./autogen.sh
	CXXFLAGS+=" -DNCURSES_WIDECHAR -U_XOPEN_SOURCE"
}
