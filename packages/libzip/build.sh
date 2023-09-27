TERMUX_PKG_HOMEPAGE=https://libzip.org/
TERMUX_PKG_DESCRIPTION="Library for reading, creating, and modifying zip archives"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/nih-at/libzip/releases/download/v$TERMUX_PKG_VERSION/libzip-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9669ae5dfe3ac5b3897536dc8466a874c8cf2c0e3b1fdd08d75b273884299363
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libbz2, liblzma, openssl, zlib, zstd"
TERMUX_PKG_BREAKS="libzip-dev"
TERMUX_PKG_REPLACES="libzip-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_GNUTLS=NO
-DENABLE_MBEDTLS=NO
-DENABLE_OPENSSL=YES
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=5

	local v=$(sed -En 's/^\s*set_target_properties\(zip\s+.*\s+SOVERSION\s+([0-9]+).*/\1/p' \
			lib/CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
