TERMUX_PKG_HOMEPAGE=https://github.com/ngtcp2/ngtcp2
TERMUX_PKG_DESCRIPTION="Implementation of IETF QUIC protocol"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.25.0"
TERMUX_PKG_SRCURL="https://github.com/ngtcp2/ngtcp2/releases/download/v$TERMUX_PKG_VERSION/ngtcp2-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=1c0843076528a87b65e9a9d455100941f4cb65d44f96c5da6ae56df146043955
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_DEPENDS="brotli"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_GNUTLS=false
-DENABLE_OPENSSL=true
-DENABLE_LIB_ONLY=true
-DHAVE_LIBBROTLIENC=true
-DHAVE_LIBBROTLIDEC=true
-DLIBBROTLIENC_LIBRARIES=$TERMUX_PREFIX/lib/libbrotlienc.so
-DLIBBROTLIDEC_LIBRARIES=$TERMUX_PREFIX/lib/libbrotlidec.so
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.

	local a
	for a in LT_CURRENT LT_AGE; do
		local _${a}="$(sed -nE "s/^set\(${a}\s*([0-9]+)\)/\1/p" CMakeLists.txt)"
	done

	local _SOVERSION=16 v="$(( _LT_CURRENT - _LT_AGE ))"
	if [[ ! "${_LT_CURRENT}" || "${v}" != "${_SOVERSION}" ]]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
