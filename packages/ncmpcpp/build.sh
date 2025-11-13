TERMUX_PKG_HOMEPAGE=https://rybczak.net/ncmpcpp/
TERMUX_PKG_DESCRIPTION="NCurses Music Player Client (Plus Plus)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.1"
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://github.com/ncmpcpp/ncmpcpp/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ddc89da86595d272282ae8726cc7913867b9517eec6e765e66e6da860b58e2f9
TERMUX_PKG_DEPENDS="boost, fftw, libandroid-support, libc++, libcurl, libicu, libmpdclient, ncurses, readline, taglib"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-clock
--enable-outputs
--enable-visualizer
--with-taglib
"

termux_step_pre_configure() {
	autoreconf -fi
	CXXFLAGS+=" -DNCURSES_WIDECHAR -U_XOPEN_SOURCE"
}
