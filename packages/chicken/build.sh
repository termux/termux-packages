TERMUX_PKG_HOMEPAGE=https://www.call-cc.org
TERMUX_PKG_DESCRIPTION="A feature rich Scheme compiler and interpreter"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.0.0"
TERMUX_PKG_SRCURL=https://code.call-cc.org/releases/${TERMUX_PKG_VERSION}/chicken-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=92835552b1b687ad26737e429b5aba36510bf429f8816ec0f6d336c8cb41f443
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
CSC_PROGRAM=chicken-csc
CSI_PROGRAM=chicken-csi
PLATFORM=android
"

termux_step_pre_configure() {
	local ARCH="${TERMUX_ARCH/_/-}" # Replace '_' in x86_64 with '-'.
	if [[ "${TERMUX_ARCH}" == "i686" ]]; then
		ARCH="x86"
	fi
	TERMUX_PKG_EXTRA_MAKE_ARGS+=" ARCH=${ARCH}"

	export C_COMPILER="$CC"
}

#chicken's configuration is not autoconf
termux_step_configure() { :; }
