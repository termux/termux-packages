TERMUX_PKG_HOMEPAGE=https://www.luanti.org
TERMUX_PKG_DESCRIPTION="An open source voxel game engine."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:5.14.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/luanti-org/luanti/archive/refs/tags/${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=b9f561fa37db3c7ea1b8ba15cfede8282b7a79b9e939b0357269c8b037cf5aea
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, jsoncpp, libandroid-spawn, libc++, libcurl, libgmp, libjpeg-turbo, libiconv, luajit, libpng, libsqlite, libvorbis, libx11, libxi, luanti-common, openal-soft, opengl, xdg-utils, zlib, zstd"
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
-DUSE_SDL2=FALSE
"

termux_step_pre_configure() {
	export LDFLAGS+=" -landroid-spawn"
	# successful application-side workaround of
	# https://github.com/kcat/openal-soft/issues/1111
	# https://github.com/termux/termux-packages/issues/23148
	export LDFLAGS+=" -Wl,--no-as-needed,-lOpenSLES,--as-needed"
}
