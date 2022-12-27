TERMUX_PKG_HOMEPAGE=https://github.com/facebook/zstd
TERMUX_PKG_DESCRIPTION="Zstandard compression"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/facebook/zstd/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f7de13462f7a82c29ab865820149e778cbfe01087b3a55b5332707abf9db4a6e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="liblzma, zlib"
TERMUX_PKG_BREAKS="zstd-dev"
TERMUX_PKG_REPLACES="zstd-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	make -j $TERMUX_MAKE_PROCESSES -C contrib/pzstd
	make -j $TERMUX_MAKE_PROCESSES -C contrib/pzstd install
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="lib/libzstd.so.1"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
