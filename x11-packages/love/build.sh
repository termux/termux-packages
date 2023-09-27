TERMUX_PKG_HOMEPAGE=https://love2d.org/
TERMUX_PKG_DESCRIPTION="A framework you can use to make 2D games in Lua"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="license.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=11.4
TERMUX_PKG_SRCURL=https://github.com/love2d/love/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=eed6e388a0c3b14150d26c6c7f64288595f4c722ee9eda0d6797ea83f2c65d23
TERMUX_PKG_DEPENDS="freetype, game-music-emu, libandroid-spawn, libc++, libluajit, libmodplug, libogg, libtheora, libvorbis, mpg123, openal-soft, opengl, sdl2, zlib"
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
