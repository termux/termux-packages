TERMUX_PKG_HOMEPAGE=https://rocksdb.org/
TERMUX_PKG_DESCRIPTION="A persistent key-value store for flash and RAM storage"
TERMUX_PKG_LICENSE="GPL-2.0, Apache-2.0, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE.Apache, LICENSE.leveldb"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.7.3
TERMUX_PKG_SRCURL=https://github.com/facebook/rocksdb/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b8ac9784a342b2e314c821f6d701148912215666ac5e9bdbccd93cf3767cb611
TERMUX_PKG_DEPENDS="gflags, libc++"
TERMUX_PKG_BUILD_DEPENDS="gflags-static"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DFAIL_ON_WARNINGS=OFF
-DPORTABLE=ON
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
