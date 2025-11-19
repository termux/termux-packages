TERMUX_PKG_HOMEPAGE=https://www.wolfssl.com/
TERMUX_PKG_DESCRIPTION="A small, fast, portable implementation of TLS/SSL for embedded devices to the cloud"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.8.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/wolfSSL/wolfssl/archive/refs/tags/v${TERMUX_PKG_VERSION}-stable.tar.gz
TERMUX_PKG_SHA256=3ef126e3466e2f8f6ebb62b916a7f8fb26c6709dbdf2b63a167759f2fdb53068
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

termux_step_pre_configure() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=44

	local a
	for a in WOLFSSL_LIBRARY_VERSION_FIRST; do
		local _${a}=$(sed -En 's/^set\('"${a}"'\s+([0-9]+).*/\1/p' \
				CMakeLists.txt)
	done
	local v=${_WOLFSSL_LIBRARY_VERSION_FIRST}
	if [ ! "${v}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed. Expected ${_SOVERSION}, got ${v}."
	fi
}
