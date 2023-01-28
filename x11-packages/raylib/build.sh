TERMUX_PKG_HOMEPAGE=https://www.raylib.com/
TERMUX_PKG_DESCRIPTION="A simple and easy-to-use library to enjoy videogames programming"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.0.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/raysan5/raylib/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=11f6087dc7bedf9efb3f69c0c872f637e421d914e5ecea99bbe7781f173dc38c
TERMUX_PKG_DEPENDS="glfw"
TERMUX_PKG_BUILD_DEPENDS="opengl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPLATFORM=Desktop
-DBUILD_EXAMPLES=OFF
-DBUILD_SHARED_LIBS=ON
-DUSE_EXTERNAL_GLFW=ON
-DOPENGL_VERSION=2.1
"

termux_step_pre_configure() {
	_NEED_DUMMY_LIBPTHREAD_A=
	_LIBPTHREAD_A=$TERMUX_PREFIX/lib/libpthread.a
	if [ ! -e $_LIBPTHREAD_A ]; then
		_NEED_DUMMY_LIBPTHREAD_A=true
		echo '!<arch>' > $_LIBPTHREAD_A
	fi
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBPTHREAD_A ]; then
		rm -f $_LIBPTHREAD_A
	fi
}
