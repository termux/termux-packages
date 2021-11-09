TERMUX_PKG_HOMEPAGE=https://github.com/lite-xl/lite-xl
TERMUX_PKG_DESCRIPTION="A lightweight text editor written in Lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@leapofazzam123"
TERMUX_PKG_VERSION=2.0.3
TERMUX_PKG_SRCURL="https://github.com/lite-xl/lite-xl/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=6c8a4ea284f102f772e3aff583236e89d5b1171664526dd501000b681ae5c4e2
TERMUX_PKG_DEPENDS="sdl2, freetype, liblua52"

termux_step_pre_configure() {
	# reproc needs librt but we don't have it
	# and we can't directly patch subprojects
	# because it needs to be patch after
	# meson downloads it
	echo 'INPUT(-lc)' > $TERMUX_PREFIX/lib/librt.so
}

termux_step_post_make_install() {
	rm $TERMUX_PREFIX/lib/librt.so
}
