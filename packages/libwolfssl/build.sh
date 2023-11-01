TERMUX_PKG_HOMEPAGE=https://www.wolfssl.com/
TERMUX_PKG_DESCRIPTION="A small, fast, portable implementation of TLS/SSL for embedded devices to the cloud"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.6.4"
TERMUX_PKG_SRCURL=https://github.com/wolfSSL/wolfssl/archive/refs/tags/v${TERMUX_PKG_VERSION}-stable.tar.gz
TERMUX_PKG_SHA256=031691906794ff45e1e792561cf31759f5d29ac74936bc8dffb8b14f16d820b4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

termux_step_pre_configure() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=41

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
