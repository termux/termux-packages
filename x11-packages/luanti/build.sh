TERMUX_PKG_HOMEPAGE=https://www.luanti.org
TERMUX_PKG_DESCRIPTION="An open source voxel game engine."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:5.11.0
TERMUX_PKG_SRCURL=https://github.com/luanti-org/luanti/archive/refs/tags/${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=70e531d0776988ce6e579ea5490fdf6be3e349a4ade5281f5111aa4fdd8ee510
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, jsoncpp, libandroid-spawn, libc++, libcurl, libgmp, libjpeg-turbo, libiconv, libluajit, libpng, libsqlite, libvorbis, libx11, libxi, luanti-common, openal-soft, opengl, xdg-utils, zlib, zstd"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SERVER=TRUE
-DBUILD_BENCHMARKS=TRUE
-DENABLE_UPDATE_CHECKER=0
-DENABLE_CURSES=0
"

termux_step_pre_configure() {
	export LDFLAGS+=" -landroid-spawn"
}
