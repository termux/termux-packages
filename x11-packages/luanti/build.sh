TERMUX_PKG_HOMEPAGE=https://www.luanti.org
TERMUX_PKG_DESCRIPTION="An open source voxel game engine."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:5.15.1"
TERMUX_PKG_SRCURL=https://github.com/luanti-org/luanti/archive/refs/tags/${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=fe0b10df866f57c0047d84a4c6f6cd848650f52d9b0cab563fbbedc81632d616
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, jsoncpp, libandroid-spawn, libc++, libcurl, libgmp, libjpeg-turbo, libiconv, luajit, libpng, libsqlite, libvorbis, luanti-common, openal-soft, opengl, sdl3, xdg-utils, zlib, zstd"
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
	# successful application-side workaround of
	# https://github.com/kcat/openal-soft/issues/1111
	# https://github.com/termux/termux-packages/issues/23148
	export LDFLAGS+=" -Wl,--no-as-needed,-lOpenSLES,--as-needed"
}
