TERMUX_PKG_HOMEPAGE=http://freeglut.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Provides functionality for small OpenGL programs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.4.0
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/freeglut/freeglut-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=3c0bcb915d9b180a97edaebd011b7a1de54583a838644dcd42bb0ea0c6f3eaec
TERMUX_PKG_DEPENDS="glu, libx11, libxi, libxrandr, opengl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_NO_TERMUX=OFF
"

termux_step_post_get_source() {
	sed -i CMakeLists.txt \
		-e 's/\([^A-Za-z0-9_]ANDROID\)\([^A-Za-z0-9_]\)/\1_NO_TERMUX\2/g' \
		-e 's/\([^A-Za-z0-9_]ANDROID\)$/\1_NO_TERMUX/g'
}
