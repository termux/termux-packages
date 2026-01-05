TERMUX_PKG_HOMEPAGE=https://rocksdb.org/
TERMUX_PKG_DESCRIPTION="A persistent key-value store for flash and RAM storage"
TERMUX_PKG_LICENSE="GPL-2.0, Apache-2.0, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE.Apache, LICENSE.leveldb"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.11.3"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://github.com/facebook/rocksdb/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=3b51d1d907ea13fab430bf052618610994f08cd8ed0b1341c3e89fe02e199f8e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gflags, libc++, libsnappy"
TERMUX_PKG_BUILD_DEPENDS="gflags-static"
# -DUSE_RTTI=ON is necessary to prevent build error
# in reverse dependency pikiwidb:
# ld.lld: error: undefined symbol: typeinfo for rocksdb::Customizable
# -DWITH_SNAPPY=ON is necessary to prevent runtime error
# in reverse dependency pikiwidb:
# open kv db failed, Invalid argument: Compression type Snappy is not linked with the binary.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DFAIL_ON_WARNINGS=OFF
-DPORTABLE=1
-DUSE_RTTI=ON
-DWITH_SNAPPY=ON
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	# in particular, check pikiwidb which might be limited to a specific range of  librocksdb
	# versions, and might have build errors if librocksdb is bumped beyond those versions.
	local _SOVERSION=8

	local v=$(grep -E "ROCKSDB_MAJOR.[0-9]" include/rocksdb/version.h | \
			cut -d ' ' -f 3)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	# needed to prevent error "'file/file_util.h' file not found"
	# in reverse dependency pikiwidb
	local dir
	for dir in file options port trace_replay monitoring util; do
		mkdir -p "$TERMUX_PKG_SRCDIR/include/rocksdb/$dir"
		cp "$TERMUX_PKG_SRCDIR/$dir"/*.h "$TERMUX_PKG_SRCDIR/include/rocksdb/$dir/"
	done
}
