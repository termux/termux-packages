TERMUX_PKG_HOMEPAGE=https://www.call-cc.org
TERMUX_PKG_DESCRIPTION="A feature rich Scheme compiler and interpreter"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.4.0"
TERMUX_PKG_SRCURL=https://code.call-cc.org/releases/${TERMUX_PKG_VERSION}/chicken-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3c5d4aa61c1167bf6d9bf9eaf891da7630ba9f5f3c15bf09515a7039bfcdec5f
TERMUX_PKG_AUTO_UPDATE=true
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
