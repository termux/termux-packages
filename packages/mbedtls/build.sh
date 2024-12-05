TERMUX_PKG_HOMEPAGE=https://tls.mbed.org/
TERMUX_PKG_DESCRIPTION="Light-weight cryptographic and SSL/TLS library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=git+https://github.com/ARMmbed/mbedtls
TERMUX_PKG_VERSION="3.6.2"
TERMUX_PKG_GIT_BRANCH=mbedtls-$TERMUX_PKG_VERSION
TERMUX_PKG_BREAKS="mbedtls-dev"
TERMUX_PKG_REPLACES="mbedtls-dev"
TERMUX_PKG_AUTO_UPDATE=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_STATIC_MBEDTLS_LIBRARY=OFF
-DUSE_SHARED_MBEDTLS_LIBRARY=ON
-DENABLE_TESTING=OFF
-DENABLE_PROGRAMS=OFF
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVER_crypto=16
	local _SOVER_tls=21
	local _SOVER_x509=7

	local f
	for f in crypto tls x509; do
		local v="$(sed -n 's/^SOEXT_'${f^^}'?=so\.//p' library/Makefile)"
		if [ "$(eval echo \$_SOVER_${f})" != "${v}" ]; then
			termux_error_exit "Error: SOVERSION guard check failed for libmbed${f}.so."
		fi
	done
}

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" = "i686" ]; then
		scripts/config.py unset MBEDTLS_AESNI_C
	fi
}
