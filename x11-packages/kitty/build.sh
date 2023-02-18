TERMUX_PKG_HOMEPAGE=https://sw.kovidgoyal.net/kitty/
TERMUX_PKG_DESCRIPTION="Cross-platform, fast, feature-rich, GPU based terminal"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# When updating the package, also update terminfo for kitty by updating
# ncurses' kitty sources in main repo
TERMUX_PKG_VERSION=0.27.1
TERMUX_PKG_SRCURL=https://github.com/kovidgoyal/kitty/releases/download/v${TERMUX_PKG_VERSION}/kitty-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e57672c5ba1973be139548eb772ff13d79c29b0ed67cbbe4418c87b6f1b1a901
# fontconfig is dlopen(3)ed:
TERMUX_PKG_DEPENDS="dbus, fontconfig, harfbuzz, libpng, librsync, libx11, libxkbcommon, littlecms, ncurses, opengl, openssl, python, zlib"
TERMUX_PKG_BUILD_DEPENDS="libxcursor, libxi, libxinerama, libxrandr, xorgproto"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="
share/doc/kitty/html
share/terminfo/x/xterm-kitty
"

termux_step_post_get_source() {
	sed 's|@TERMUX_PREFIX@|'"$TERMUX_PREFIX"'|g' \
		$TERMUX_PKG_BUILDER_DIR/posix-shm.c.in > kitty/posix-shm.c
	cp $TERMUX_PKG_BUILDER_DIR/reallocarray.c glfw/
}

termux_step_pre_configure() {
	termux_setup_golang

	CFLAGS+=" $CPPFLAGS"
}

termux_step_make() {
	python setup.py linux-package \
		--ignore-compiler-warnings \
		--verbose
}

termux_step_make_install() {
	cp -rT linux-package $TERMUX_PREFIX
}
