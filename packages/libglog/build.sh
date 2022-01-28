TERMUX_PKG_HOMEPAGE=https://github.com/google/glog
TERMUX_PKG_DESCRIPTION="A C++98 library that implements application-level logging"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.0
TERMUX_PKG_SRCURL=https://github.com/google/glog/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=eede71f28371bf39aa69b45de23b329d37214016e2055269b3b5e7cfd40b59f5
TERMUX_PKG_DEPENDS="libandroid-glob, libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_GFLAGS=OFF
-DWITH_GTEST=OFF
-DWITH_SYMBOLIZE=OFF
-DWITH_UNWIND=OFF
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"

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
