TERMUX_PKG_HOMEPAGE=https://rocksdb.org/
TERMUX_PKG_DESCRIPTION="A persistent key-value store for flash and RAM storage"
TERMUX_PKG_LICENSE="GPL-2.0, Apache-2.0, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE.Apache, LICENSE.leveldb"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.9.2
TERMUX_PKG_SRCURL=https://github.com/facebook/rocksdb/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=886378093098a1b2521b824782db7f7dd86224c232cf9652fcaf88222420b292
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gflags, libc++"
TERMUX_PKG_BUILD_DEPENDS="gflags-static"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DFAIL_ON_WARNINGS=OFF
-DPORTABLE=ON
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=7

	local v=$(grep -E "ROCKSDB_MAJOR.[0-9]" include/rocksdb/version.h | \
			cut -d ' ' -f 3)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

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
