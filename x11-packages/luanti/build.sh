TERMUX_PKG_HOMEPAGE=https://www.luanti.org
TERMUX_PKG_DESCRIPTION="An open source voxel game engine."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:5.17.0"
TERMUX_PKG_SRCURL="https://github.com/luanti-org/luanti/archive/refs/tags/${TERMUX_PKG_VERSION:2}.tar.gz"
TERMUX_PKG_SHA256=52e7dd315ae0e5c3868a23231e691578cd694bcca5af627fc57c03f32bdc846f
TERMUX_PKG_AUTO_UPDATE=true
# libandroid-stub is required to prevent large ELF executables that depend on harfbuzz, or any
# of whose dependencies depend on harfbuzz, recursively,
# from conflicting with the libharfbuzz_ng.so that some Android ROMs' libOpenSLES.so libraries
# depend on, which would otherwise cause no audio output on some devices.
TERMUX_PKG_DEPENDS="freetype, jsoncpp, libandroid-spawn, libandroid-stub, libc++, libcurl, libgmp, libjpeg-turbo, libiconv, luajit, libpng, libsqlite, libvorbis, luanti-common, openal-soft, opengl, sdl3, xdg-utils, zlib, zstd"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SERVER=TRUE
-DBUILD_BENCHMARKS=TRUE
-DENABLE_CURL=TRUE
-DENABLE_GETTEXT=TRUE
-DENABLE_LUAJIT=TRUE
-DENABLE_SYSTEM_GMP=TRUE
-DENABLE_SYSTEM_JSONCPP=TRUE
-DENABLE_OPENSSL=TRUE
-DENABLE_POSTGRESQL=FALSE
-DENABLE_UPDATE_CHECKER=FALSE
-DENABLE_CURSES=FALSE
-DENABLE_LEVELDB=FALSE
-DENABLE_SPATIAL=FALSE
-DENABLE_LTO=FALSE
-DENABLE_REDIS=FALSE
-DENABLE_PROMETHEUS=FALSE
-DUSE_SDL3=TRUE
"

termux_step_pre_configure() {
	export LDFLAGS+=" -landroid-spawn"
}
