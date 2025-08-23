TERMUX_PKG_HOMEPAGE=https://gitlab.com/AOMediaCodec/SVT-AV1
TERMUX_PKG_DESCRIPTION="Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder)"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE.md, PATENTS.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.1"
TERMUX_PKG_SRCURL=https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v${TERMUX_PKG_VERSION}/SVT-AV1-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9989429f8dd30953f0b853ccfe876bca9b789577f0d760daa8ded4093ad15d17
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTING=OFF
-DCMAKE_OUTPUT_DIRECTORY=$TERMUX_PKG_BUILDDIR
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _ENC_SOVERSION=3

	local _enc_soverion=$(sed -En 's/^set\(ENC_VERSION_MAJOR\s+([0-9.]+).*/\1/p' \
			Source/Lib/CMakeLists.txt)
	if [ ! "${_enc_soverion}" ] || [ "${_ENC_SOVERSION}" != "${_enc_soverion}" ]; then
		termux_error_exit "SOVERSION guard check failed. Expected ${_enc_soverion}, got ${_ENC_SOVERSION}."
	fi
}

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
	case "${TERMUX_ARCH}" in
	x86_64) LDFLAGS+=" -llog" ;;
	esac
}
