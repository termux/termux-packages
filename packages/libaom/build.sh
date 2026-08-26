TERMUX_PKG_HOMEPAGE=https://aomedia.org/
TERMUX_PKG_DESCRIPTION="AV1 Video Codec Library"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, PATENTS"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.15.0"
TERMUX_PKG_SRCURL=https://storage.googleapis.com/aom-releases/libaom-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ea08c38ecc078bc85bb1b691020e52b06250f1a81fe7ca5b624629225081af96
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
"

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
