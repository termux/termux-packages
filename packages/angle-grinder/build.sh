TERMUX_PKG_HOMEPAGE=https://github.com/rcoh/angle-grinder
TERMUX_PKG_DESCRIPTION="Slice and dice logs on the command line"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.19.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/rcoh/angle-grinder/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f76e236f0825ca3f0b165e37d6448fa36e39c41690e7469d02c37eeb0c972222
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# ld: error: undefined symbol: __emutls_get_address
	if [[ "${TERMUX_ARCH}" == "arm" ]]; then
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
	fi
}
