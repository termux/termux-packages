TERMUX_PKG_HOMEPAGE=https://www.luanti.org
TERMUX_PKG_DESCRIPTION="An open source voxel game engine."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:5.12.0
TERMUX_PKG_SRCURL=https://github.com/luanti-org/luanti/archive/refs/tags/${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=876867ac874492f20968f2c2eb4e403231e8e9f29e0e06efa512200bd5152355
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, jsoncpp, libandroid-spawn, libc++, libcurl, libgmp, libjpeg-turbo, libiconv, libluajit, libpng, libsqlite, libvorbis, libx11, libxi, luanti-common, openal-soft, opengl, xdg-utils, zlib, zstd"
# In 5.12.0, luanti upstream officially migrated to SDL2,
# but for now, enabling SDL2 in Termux would:
# - disable EGL support, which would significantly reduce performance and driver compatibility
# - make the colors of everything strangely washed out
# so it makes more sense to keep SDL2 disabled in this luanti for now,
# since the non-SDL2 mode seems to continue to work without problems.
# Enable SDL2 in the future when possible, after the above problems are gone.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SERVER=TRUE
-DBUILD_BENCHMARKS=TRUE
-DENABLE_UPDATE_CHECKER=0
-DENABLE_CURSES=0
-DUSE_SDL2=0
"

termux_step_pre_configure() {
	export LDFLAGS+=" -landroid-spawn"
	# successful application-side workaround of
	# https://github.com/kcat/openal-soft/issues/1111
	# https://github.com/termux/termux-packages/issues/23148
	export LDFLAGS+=" -Wl,--no-as-needed,-lOpenSLES,--as-needed"
}
