TERMUX_PKG_HOMEPAGE=https://www.luanti.org
TERMUX_PKG_DESCRIPTION="An open source voxel game engine."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:5.10.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/minetest/minetest/archive/refs/tags/${TERMUX_PKG_VERSION:2}.zip
TERMUX_PKG_SHA256=e74e994c0f1b188d60969477f553ad83b8ce20ee1e0e2dcd068120189cb0f56c
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
