TERMUX_PKG_HOMEPAGE=https://www.wolfssl.com/
TERMUX_PKG_DESCRIPTION="A small, fast, portable implementation of TLS/SSL for embedded devices to the cloud"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.5.4
TERMUX_PKG_SRCURL=https://github.com/wolfSSL/wolfssl/archive/refs/tags/v${TERMUX_PKG_VERSION}-stable.tar.gz
TERMUX_PKG_SHA256=b7ee150e49def77c765bc02aac92ddeb0bebefd4cb12aa263d8f95e405221fb8
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=35

	local a
	for a in LIBTOOL_CURRENT LIBTOOL_AGE; do
		local _${a}=$(sed -En 's/^set\('"${a}"'\s+([0-9]+).*/\1/p' \
				CMakeLists.txt)
	done
	local v=$(( _LIBTOOL_CURRENT - _LIBTOOL_AGE ))
	if [ ! "${_LIBTOOL_CURRENT}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
