TERMUX_PKG_HOMEPAGE=https://gitlab.com/AOMediaCodec/SVT-AV1
TERMUX_PKG_DESCRIPTION="Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder)"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE.md, PATENTS.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.0"
TERMUX_PKG_SRCURL=https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v${TERMUX_PKG_VERSION}/SVT-AV1-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=72a076807544f3b269518ab11656f77358284da7782cece497781ab64ed4cb8a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTING=OFF
-DCMAKE_OUTPUT_DIRECTORY=$TERMUX_PKG_BUILDDIR
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _ENC_SOVERSION=2
	local _DEC_SOVERSION=0

	local _enc_soverion=$(sed -En 's/^set\(ENC_VERSION_MAJOR\s+([0-9.]+).*/\1/p' \
			Source/Lib/Encoder/CMakeLists.txt)
	if [ ! "${_enc_soverion}" ] || [ "${_ENC_SOVERSION}" != "${_enc_soverion}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
	local _dec_soverion=$(sed -En 's/^set\(DEC_VERSION_MAJOR\s+([0-9.]+).*/\1/p' \
			Source/Lib/Decoder/CMakeLists.txt)
	if [ ! "${_dec_soverion}" ] || [ "${_DEC_SOVERSION}" != "${_dec_soverion}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
	case "${TERMUX_ARCH}" in
	x86_64) LDFLAGS+=" -llog" ;;
	esac
}
