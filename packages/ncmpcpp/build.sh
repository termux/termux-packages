TERMUX_PKG_HOMEPAGE=https://rybczak.net/ncmpcpp/
TERMUX_PKG_DESCRIPTION="NCurses Music Player Client (Plus Plus)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://rybczak.net/ncmpcpp/stable/ncmpcpp-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b
TERMUX_PKG_DEPENDS="fftw, boost, readline, libandroid-support, libc++, libcurl, libicu, libmpdclient, ncurses, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-visualizer --enable-outputs --enable-clock"

termux_step_pre_configure() {
	./autogen.sh
	CXXFLAGS+=" -DNCURSES_WIDECHAR -U_XOPEN_SOURCE"
}
