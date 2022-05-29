TERMUX_PKG_HOMEPAGE=https://www.call-cc.org
TERMUX_PKG_DESCRIPTION="A feature rich Scheme compiler and interpreter"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.3.0
TERMUX_PKG_SRCURL=https://code.call-cc.org/releases/${TERMUX_PKG_VERSION}/chicken-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c3ad99d8f9e17ed810912ef981ac3b0c2e2f46fb0ecc033b5c3b6dca1bdb0d76
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PLATFORM=android"

termux_step_pre_configure() {
	local ARCH="${TERMUX_ARCH/_/-}" # Replace '_' in x86_64 with '-'.
	if [[ "${TERMUX_ARCH}" == "i686" ]]; then
		ARCH="x86"
	fi
	TERMUX_PKG_EXTRA_MAKE_ARGS+=" ARCH=${ARCH}"

	export C_COMPILER="$CC"
}
