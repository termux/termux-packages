TERMUX_PKG_HOMEPAGE=https://libzip.org/
TERMUX_PKG_DESCRIPTION="Library for reading, creating, and modifying zip archives"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.11.2"
TERMUX_PKG_SRCURL=https://github.com/nih-at/libzip/releases/download/v$TERMUX_PKG_VERSION/libzip-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6b2a43837005e1c23fdfee532b78f806863e412d2089b9c42b49ab08cbcd7665
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
