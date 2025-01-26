TERMUX_PKG_HOMEPAGE=https://love2d.org/
TERMUX_PKG_DESCRIPTION="A framework you can use to make 2D games in Lua"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="license.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="11.5"
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://github.com/love2d/love/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6f55c265be5e03696c4770150c4388f5cffbdb3727606724cf88332baab429f7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, game-music-emu, libandroid-spawn, libc++, libluajit, libmodplug, libogg, libtheora, libvorbis, mpg123, openal-soft, opengl, sdl2 | sdl2-compat, zlib"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-gme
"

termux_step_pre_configure() {
	mkdir -p platform/unix/m4
	ln -sf $TERMUX_PREFIX/share/aclocal/sdl2.m4 platform/unix/m4/
	local _orig_prefix=${prefix}
	unset prefix
	./platform/unix/automagic
	export prefix=${_orig_prefix}

	export OBJCXX="$CXX"
	LDFLAGS+=" -landroid-spawn"
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
