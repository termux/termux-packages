TERMUX_PKG_HOMEPAGE=https://gitlab.com/AOMediaCodec/SVT-AV1
TERMUX_PKG_DESCRIPTION="Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder)"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE.md, PATENTS.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.1"
TERMUX_PKG_SRCURL=https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v${TERMUX_PKG_VERSION}/SVT-AV1-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=03b3cf985b52da294f241cbd2b0a8996a34f817fa75c4e8f9dc1bb6458d24de2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTING=OFF
-DCMAKE_OUTPUT_DIRECTORY=$TERMUX_PKG_BUILDDIR
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _ENC_SOVERSION=2

	local _enc_soverion=$(sed -En 's/^set\(ENC_VERSION_MAJOR\s+([0-9.]+).*/\1/p' \
			Source/Lib/CMakeLists.txt)
	if [ ! "${_enc_soverion}" ] || [ "${_ENC_SOVERSION}" != "${_enc_soverion}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
	case "${TERMUX_ARCH}" in
	x86_64) LDFLAGS+=" -llog" ;;
	esac
}
