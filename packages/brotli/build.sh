TERMUX_PKG_HOMEPAGE=https://github.com/google/brotli
TERMUX_PKG_DESCRIPTION="lossless compression algorithm and format (command line utility)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.9
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/google/brotli/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f9e8d81d0405ba66d181529af42a3354f838c939095ff99930da6aa9cdf6fe46
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="brotli-dev"
TERMUX_PKG_REPLACES="brotli-dev"
TERMUX_PKG_FORCE_CMAKE=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=1

	local _ABI_VERSION=$(sed -En 's/^#define BROTLI_ABI_VERSION (0x[0-9a-fA-F]+)$/\1/p' \
			c/common/version.h)
	local _ABI_CURRENT=$(( _ABI_VERSION >> 24 ))
	local _ABI_AGE=$(( _ABI_VERSION & 4095 ))
	local v=$(( _ABI_CURRENT - _ABI_AGE ))
	if [ ! "${_ABI_VERSION}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man{1,3}
	cp $TERMUX_PKG_SRCDIR/docs/brotli.1 $TERMUX_PREFIX/share/man/man1/
	cp $TERMUX_PKG_SRCDIR/docs/*.3 $TERMUX_PREFIX/share/man/man3/
}
