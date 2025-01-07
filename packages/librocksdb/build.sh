TERMUX_PKG_HOMEPAGE=https://rocksdb.org/
TERMUX_PKG_DESCRIPTION="A persistent key-value store for flash and RAM storage"
TERMUX_PKG_LICENSE="GPL-2.0, Apache-2.0, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE.Apache, LICENSE.leveldb"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.11.3"
TERMUX_PKG_SRCURL=https://github.com/facebook/rocksdb/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3b51d1d907ea13fab430bf052618610994f08cd8ed0b1341c3e89fe02e199f8e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gflags, libc++"
TERMUX_PKG_BUILD_DEPENDS="gflags-static"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DFAIL_ON_WARNINGS=OFF
-DPORTABLE=1
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=8

	local v=$(grep -E "ROCKSDB_MAJOR.[0-9]" include/rocksdb/version.h | \
			cut -d ' ' -f 3)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
