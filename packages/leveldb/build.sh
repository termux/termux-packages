TERMUX_PKG_HOMEPAGE=https://github.com/google/leveldb
TERMUX_PKG_DESCRIPTION="Fast key-value storage library"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.23
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/google/leveldb/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9a37f8a6174f09bd622bc723b55881dc541cd50747cbd08831c2a82d620f6d76
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="leveldb-dev"
TERMUX_PKG_REPLACES="leveldb-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=TRUE
-DLEVELDB_BUILD_TESTS=OFF
-DLEVELDB_BUILD_BENCHMARKS=OFF
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=1

	local v=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 1)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
