TERMUX_PKG_HOMEPAGE=https://aomedia.org/
TERMUX_PKG_DESCRIPTION="AV1 Video Codec Library"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, PATENTS"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.9.0
TERMUX_PKG_SRCURL=git+https://aomedia.googlesource.com/aom
TERMUX_PKG_SHA256=e5be735a080f8e5ca440df979e829e7c369e343b99a86153f6d588ba97bc736b
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DCMAKE_INSTALL_LIBDIR=lib
"

termux_step_post_get_source() {
	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		echo "$s"
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_pre_configure() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=3

	local a
	for a in LT_CURRENT LT_AGE; do
		local _${a}=$(sed -En 's/^set\('"${a}"'\s+([0-9]+).*/\1/p' \
				CMakeLists.txt)
	done
	local v=$(( _LT_CURRENT - _LT_AGE ))
	if [ ! "${_LT_CURRENT}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
