TERMUX_PKG_HOMEPAGE=https://mgba.io/
TERMUX_PKG_DESCRIPTION="An emulator for running Game Boy Advance games"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.2"
TERMUX_PKG_SRCURL=https://github.com/mgba-emu/mgba/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=60afef8fb79ba1f7be565b737bae73c6604a790391c737f291482a7422d675ae
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ffmpeg, libedit, libelf, liblua54, libpng, libsqlite, libzip, opengl, sdl2, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_GLES2=OFF
-DBUILD_GLES3=OFF
-DBUILD_QT=OFF
-DLUA_MATH_LIBRARY=m
-DUSE_EPOXY=OFF
-DUSE_LUA=5.4
-DUSE_MINIZIP=OFF
"

termux_step_pre_configure() {
	CPPFLAGS+=" -DHAVE_STRTOF_L"
}
