# x11-packages
TERMUX_PKG_HOMEPAGE=https://love2d.org/
TERMUX_PKG_DESCRIPTION="A framework you can use to make 2D games in Lua"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="license.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.10.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/love2d/love/releases/download/${TERMUX_PKG_VERSION}/love-${TERMUX_PKG_VERSION}-linux-src.tar.gz
TERMUX_PKG_SHA256=b26b306b113158927ae12d2faadb606eb1db49ffdcd7592d6a0a3fc0af21a387
TERMUX_PKG_DEPENDS="freetype, game-music-emu, libandroid-spawn, libc++, libluajit, libmodplug, libogg, libphysfs, libtheora, libvorbis, mpg123, openal-soft, opengl, sdl2, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-gme
--with-lua=luajit
ac_cv_prog_LUA_EXECUTABLE=luajit
"

termux_step_pre_configure() {
	case "$TERMUX_PKG_VERSION" in
		0.10.*|*:0.10.* ) ;;
		* ) termux_error_exit "Invalid version '$TERMUX_PKG_VERSION' for package '$TERMUX_PKG_NAME'." ;;
	esac

	export OBJCXX="$CXX"
	CPPFLAGS+=" -DluaL_reg=luaL_Reg"
	LDFLAGS+=" -landroid-spawn"
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
