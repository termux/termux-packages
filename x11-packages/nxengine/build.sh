TERMUX_PKG_HOMEPAGE=https://nxengine.sourceforge.net
TERMUX_PKG_DESCRIPTION="Open-source rewrite engine of the Cave Story for Dingux and MotoMAGX"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@Yonle"
TERMUX_PKG_VERSION=1.0.0.4-Rev4
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/EXL/NXEngine/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d467c112e81d4c56337ebf6968bd8bd781bce9140f674e72009a5274d2c15784
TERMUX_PKG_DEPENDS="libc++, pulseaudio, sdl, sdl-ttf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make -j $TERMUX_MAKE_PROCESSES -f Makefile.linux \
		CC="$CC" \
		CXX="$CXX" \
		LINK="$CXX" \
		CFLAGS="$CFLAGS $CPPFLAGS -Wno-c++11-narrowing" \
		CXXFLAGS="$CXXFLAGS $CPPFLAGS -Wno-c++11-narrowing" \
		LFLAGS="$LDFLAGS"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin ./nx
	install -Dm600 -t $TERMUX_PREFIX/share/nxengine \
		smalfont.bmp DroidSansMono.ttf font.ttf \
		sprites.sif tilekey.dat
}
